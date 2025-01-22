<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Banco
 *
 */
class ManagerSuscripcionPremium extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "suscripcion_premium", "idsuscripcion_premium");
    }

    /*     * Metodo que crea una nueva suscripcion de cuenta premium
     *  @param type $request
     */

    public function nuevaSuscripcion($request = null) {


        $request["idmedico"] = (is_null($request) || !isset($request["idmedico"])) ? $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] : $request["idmedico"];
        //verificamos la suscripcion existente este vigente todavia
        $suscripcion_actual = $this->getSuscripcionActiva($request["idmedico"]);
        if ($suscripcion_actual["vencida"] == "0") {
            $this->setMsg(["msg" => "Ya posee una Cuenta Profesional", "result" => false]);
            return false;
        }

        //insertamos una nueva inscripcion
        $this->db->StartTrans();
        $arr["medico_idmedico"] = $request["idmedico"];
        $arr["fecha_inicio"] = date("Y-m-d");
        //$arr["fecha_fin"] = date("Y-m-d", mktime(0, 0, 0, date("m") + CANTIDAD_MESES_SUSCRIPCION, date("d"), date("Y")));
        $arr["fecha_fin"] = date("Y-m-d", mktime(0, 0, 0, date("m") , date("d"), date("Y")+10));
        $arr["activa"] = 0;
        $idsuscripcion = $this->insert($arr);


        $record["suscripcion_premium_idsuscripcionactiva"] = $idsuscripcion;
        $rdo1 = $this->getManager("ManagerMedico")->basic_update($record, $request["idmedico"]);

        if ($rdo1 && $idsuscripcion) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Cuenta Profesional creada con exito", "result" => true, "id" => $idsuscripcion]);
            
            // <-- LOG
            $log["data"] = "Subscribe monthly subscription,";
            $log["page"] = "Account settings";          
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Type of account";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--
        
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "No se pudo crear la Cuenta Profesional", "result" => false]);
            return false;
        }
    }

    /** 
     * Gestion de suscripciones premium de medicos desde el xadmin
     * @param type $request
     * @return boolean
     */
    public function processSuscripcionFromXadmin($request) {

        //creamos una nueva suscrpcion premium       
        if ($request["activar"] == 1) {

            $suscripcion_actual = $this->getSuscripcionActiva($request["medico_idmedico"]);
        
            //insertamos una nueva inscripcion
            $this->db->StartTrans();
            $arr["medico_idmedico"] = $request["medico_idmedico"];
            $arr["fecha_inicio"] = date("Y-m-d");
            if ($request["cantidad_meses"] == "13") {
                $request["cantidad_meses"] = 360;
                $record["fundador"] = 1;
            }
            $arr["fecha_fin"] = date("Y-m-d", mktime(0, 0, 0, date("m") + $request["cantidad_meses"], date("d"), date("Y")));
            $arr["activa"] = 1;
            $arr["from_admin"] = 1;
            $idsuscripcion = $this->insert($arr);

            //actualizamos el estado del medico
            $record["fecha_vto_premium"] = $arr["fecha_fin"];
            $record["planProfesional"] = 1;

            $record["suscripcion_premium_idsuscripcionactiva"] = $idsuscripcion;
            $rdo1 = $this->getManager("ManagerMedico")->basic_update($record, $request["medico_idmedico"]);


            if ($rdo1 && $idsuscripcion) {
                if ($request["cantidad_meses"] == "13") {
                    $this->setMsg(["msg" => "Médico fundador creado con exito", "result" => true, "id" => $idsuscripcion]);
                } else {
                    $this->setMsg(["msg" => "Cuenta Profesional creada con exito", "result" => true, "id" => $idsuscripcion]);
                }
                $this->db->CompleteTrans();
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "No se pudo crear la Cuenta Profesional", "result" => false]);
                return false;
            }
        } else {
            
            //desactivamos la suscripcion premium
            $suscripcion_actual = $this->getSuscripcionActiva($request["medico_idmedico"]);
            $this->db->StartTrans();
            $idsuscripcion = true;
            if ($suscripcion_actual) {
                $arr["activa"] = 0;
                $idsuscripcion = $this->update($arr, $suscripcion_actual["idsuscripcion_premium"]);
            }
            //insertamos una nueva inscripcion


            $record["suscripcion_premium_idsuscripcionactiva"] = NULL;
            $record["fecha_vto_premium"] = NULL;
            $record["planProfesional"] = 0;
            $record["fundador"] = 0;
            $rdo1 = $this->getManager("ManagerMedico")->basic_update($record, $request["medico_idmedico"]);

            if ($rdo1 && $idsuscripcion) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Cuenta Profesional desactivada con exito", "result" => true, "id" => $idsuscripcion]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "No se pudo desactivar la Cuenta Profesional", "result" => false]);
                return false;
            }
        }
    }

//END_nuevaSuscripcion

    /*     * Metodo que retorna la suscripcion premium del medico activa donde la fecha actual se encuentra en el rango de la suscripcion
     * 
     * @param type $idmedico
     * @return type
     */

    public function getSuscripcionActiva($idmedico) {
        
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico and activa=1");
        $query->setOrderBy("fecha_fin ASC");

        $rdo = $this->db->getRow($query->getSql());
        $fecha_actual = date("Y-m-d");
        $fecha_fin = strtotime($rdo["fecha_fin"]);
        if ($rdo["idsuscripcion_premium"] != "") {
            $rdo["pagos"] = $this->getManager("ManagerCuota")->getPagosList($rdo["idsuscripcion_premium"], $rdo["fecha_inicio"]);
            if ($fecha_actual > $fecha_fin) {
                $rdo["vencida"] = 1;
            } else {
                $rdo["vencida"] = 0;
            }
        }

        return $rdo;
    }

    /** 
     * Cron que se ejecuta a las 00:00hs encargado de vencer las suscripciones premium que han pasado 2 dias de vencimiento sin pagarse la cuota
     * 
     */
     public function cronVerificarSuscripcionActiva() {
       /* 
        $this->db->StartTrans();
        $rdo = $this->db->execute("update medico set planProfesional=0,suscripcion_premium_idsuscripcionactiva= NULL,fecha_vto_premium=NULL WHERE planProfesional=1 and DATEDIFF(CURRENT_DATE(),fecha_vto_premium)>=2 ");
        $rdo2 = $this->db->execute("update  medico m join preferencia p ON (m.preferencia_idPreferencia=p.idpreferencia) set pacientesConsultaExpress=1,pacientesVideoConsulta=1 where planProfesional=0");
        if ($rdo && $rdo2) {
            $this->db->CompleteTrans();
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
        }*/
    }

    /**
     * Activa una suscripcion premium que fue realizada mediante stripe
     * @param  [type] $request [description]
     * @return [type]          [description]
     */
    public function activarSuscripcionStripe($request){
        
        $this->db->StartTrans();
        
        //traigo la suscripcion
        $idsuscripcion = $request["idsuscripcion"];
        $suscripcion = $this->get($idsuscripcion);

        //modifico el medico
        $this->db->Execute("UPDATE medico SET planProfesional=1 WHERE idmedico = {$suscripcion["medico_idmedico"]}");

        //modifico la suscripcion
        $rdo = $this->update(["activa"=>1, "idsuscripcion_stripe"=>$request["idsuscripcion_stripe"]], $idsuscripcion);
        //$this->db->FailTrans();
        $this->db->CompleteTrans();
        return $rdo;
    }

    /**
     * Cancela una suscripcion premium
     * @param  int $idsuscripcion 
     * @return [type]
     */
    public function cancelarSuscripcion($idsuscripcion){
        
        // <-- LOG
        $log["data"] = "Cancel monthly subscription";
        $log["page"] = "Account settings";          
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Type of account";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--
        
        $suscripcion = $this->get($idsuscripcion);
        if(!empty($suscripcion["idsuscripcion_stripe"])){//stripe
            $rdoCancel = $this->getManager("ManagerMetodoPago")->cancelSubscriptionStripe($suscripcion["idsuscripcion_stripe"]);
        }else{
            $rdoCancel = true;
        }

        if(empty($rdoCancel)){//fallo la cancelacion en Stripe
            $this->setMsg(["result" => true, "msg" => "Error. No se ha podido cancelar la suscripción."]);
            return false;
        }

        $this->db->StartTrans();

        //actualizo el medico
        $this->db->Execute("UPDATE medico SET planProfesional=0 WHERE idmedico = {$suscripcion["medico_idmedico"]}");        

        //actualizo la suscripcion
        $this->update(["activa"=>0], $idsuscripcion);

        $this->db->CompleteTrans();
        
        // <-- LOG
        $log["data"] = "confirmation choice cancelation subscription";
        $log["page"] = "Account detail";          
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Cancelation subscription";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);

        // <--
        
        
        $this->setMsg(["result" => true, "msg" => "Se ha cancelado exitosamente la suscripción."]);        
        return $rdoCancel;
    }

}//END_class