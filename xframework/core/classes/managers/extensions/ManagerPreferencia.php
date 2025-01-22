<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	11/07/2014
 * 	Manager de las preferencias de los médicos
 *
 */
class ManagerPreferencia extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "preferencia", "idpreferencia");
    }

    public function registar_aranceles($request) {

        $managerMedico = $this->getManager("ManagerMedico");
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $medico = $managerMedico->get($idmedico);

        //medico frances de sector 1 no tiene tarifa VC inmediata
        if ($medico["pais_idpais"] == 1 && $medico["sector_idsector"] == 1) {
            $request["valorPinesVideoConsulta"] = $request["valorPinesVideoConsultaTurno"];
            if (($request["valorPinesConsultaExpress"] == "" || $request["valorPinesConsultaExpress"] < PRECIO_MINIMO_CE) || ($request["valorPinesVideoConsultaTurno"] == "" || $request["valorPinesVideoConsultaTurno"] < PRECIO_MINIMO_VC_TURNO)
            ) {
                $this->setMsg(["result" => false, "msg" => "Las tarifas ingresadas no son válidas"]);
                return false;
            }
        } else {
            if (($request["valorPinesConsultaExpress"] == "" || $request["valorPinesConsultaExpress"] < PRECIO_MINIMO_CE) || ($request["valorPinesVideoConsultaTurno"] == "" || $request["valorPinesVideoConsultaTurno"] < PRECIO_MINIMO_VC_TURNO) || ($request["valorPinesVideoConsulta"] == "" || $request["valorPinesVideoConsulta"] < PRECIO_MINIMO_VC)
            ) {
                $this->setMsg(["result" => false, "msg" => "Las tarifas ingresadas no son válidas"]);
                return false;
            }
        }


        $especialidad = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($idmedico)[0];

        if ($medico["pais_idpais"] == 1) {
            if ($medico["sector_idsector"] == "" && $especialidad["requiere_sector"] == 1) {

                $this->setMsg(["result" => false, "msg" => "Error. No ha configurado el sector en su Información Profesional"]);
                return false;
            }
            if ($especialidad["tipo"] == 1 && $medico["sector_idsector"] == 1) {

                if ($especialidad["max_vc_turno"] != "" && $request["valorPinesVideoConsultaTurno"] != $especialidad["max_vc_turno"]) {
                    $this->setMsg(["result" => false, "msg" => "La tarifa de Video Consulta con Turno que entro no es consistente con la tarifa Sector 1 [[(€{$especialidad["max_vc_turno"]})]]. Si quiere entrar otra tarifa, tiene que modificar su categoría de sector primero para poder luego agregar una tarifa libre"]);
                    return false;
                }
            }
        }


        //verificamos si compelto los datos minimos requeridos
        $info_medico = $managerMedico->getInfoMenuMedico($idmedico);
        $showModal = false;



        $id = parent::process($request);
        if ($id > 0) {
            //Si se registra la preferencia, que se la asigne al médico
            $update = array("preferencia_idPreferencia" => $id);

            $managerMedico->update($update, $idmedico);
            $tarifas = parent::get($id);
            // verificamos si completa la info
            if ($info_medico["consultorio_virtual"]["idconsultorio"] != "" && //tiene consultorio virtual
                    $info_medico["medico"]["direccion_iddireccion"] != "" && //tiene direccion
                    (($info_medico["medico"]["preferencia"]["valorPinesVideoConsultaTurno"] == "" && $tarifas["valorPinesVideoConsultaTurno"] != "") || //completa tarifa
                    ($info_medico["medico"]["preferencia"]["valorPinesVideoConsulta"] == "" && $tarifas["valorPinesVideoConsulta"] != "") ||//completa tarifa
                    ($info_medico["medico"]["preferencia"]["valorPinesConsultaExpress"] == "" && $tarifas["valorPinesConsultaExpress"] != "")
                    )) {
                // En este caso forzamos a mostrar el modal.
                $showModal = true;
            }

            //verificamos si se lo ha agregado a profesionales frecuentes

            $this->getManager("ManagerPacienteMedicoInvitacion")->verificarInvitacionesProfesionalesFrecuentes($medico);
            $this->setMsg(["result" => true, "msg" => "Se han registrado sus aranceles", "showModal" => $showModal]);

            // <-- LOG
            $log["data"] = "User preferences and fees for each service";
            $log["page"] = "Professional information";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Update services and fees";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 

            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Se ha producido un error al registrar sus aranceles"]);
            return false;
        }
    }

    /**
     *  Guarda las preferencias de los servicios de CE y VC de un medico
     *
     * */
    public function guardarPreferenciaServicios($request) {

        if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']) && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {

            $to_save = array("pacientesConsultaExpress", "pacientesVideoConsulta"); //Atencion!!! Agregar campos que hagan falta para guardar

            $fields = array();

            foreach ($request as $key => $value) {
                if (in_array($key, $to_save)) {
                    $fields[$key] = $value;
                }
            }


            $preferencia = $this->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

            if (count($fields) > 0 && ($request["pacientesConsultaExpress"] == "1" || $request["pacientesConsultaExpress"] == "2" || $request["pacientesVideoConsulta"] == "1" || $request["pacientesVideoConsulta"] == "2")) {

                $result = $this->update(
                        $fields, $preferencia["idpreferencia"]
                );
            }

            if ($result > 0) {
                $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito la informacion de servicios brindados"]);

                // <-- LOG
                $log["data"] = "Type of services offered, type of notifications";
                $log["page"] = "Account settings";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "User preferences";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);

                // <--


                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, no hemos podido guardar la informacion de servicios brindados"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *  Guarda las preferencias de los medios por los que desea recibir notificaciones del sistema el medico
     * 1:EMAIL
     * 2:SMS
     * 3:AMBOS
     *
     * */
    public function guardarPreferenciaNotificacion($request) {

        if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']) && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {



            $preferencia = $this->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

            if ($request["sms"] == "1" || $request["sms"] == "0" || $request["email"] == "1" || $request["email"] == "0") {
                /* Fix siempre enviamos SMS */
                $record["recibirNotificacionSistemaSMS"] = 1;
                $record["recibirNotificacionSistemaEmail"] = $request["email"];
                $result = $this->update(
                        $record, $preferencia["idpreferencia"]
                );
            }

            if ($result > 0) {
                $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito la informacion de notificaciones"]);

                // <-- LOG
                $log["data"] = "Type of services offered, type of notifications";
                $log["page"] = "Account settings";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "User preferences";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);

                // <--

                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, no hemos podido guardar la informacion de notificaciones"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *  Guarda las preferencias de los medios sobre si desean renovar automaticamente una cuenta profesional
     * 1:SI
     * 0:NO
     *
     * */
    public function registrarRenovacionAutomatica($val) {

        if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']) && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {



            $preferencia = $this->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

            if ($val == "1" || $val == "0") {
                $record["renovarCuentaProfesionalAutomatica"] = $val;

                $result = $this->update(
                        $record, $preferencia["idpreferencia"]
                );
            }

            if ($result > 0) {
                $this->setMsg(["result" => true, "msg" => "Se ha actualizado con éxito la información"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, no hemos podido guardar la información"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, acceso denegado"]);
            return false;
        }
    }

    /**
     *
     *  Combo con las posibles duraciones de turnos
     *
     * */
    public function getComboDuracionTurnos() {

        return array(
            15 => "15 min",
            20 => "20 min",
            30 => "30 min",
            45 => "45 min",
            60 => "60 min"
        );
    }

    /**
     *  Obtiene el registro de preferencia de un medico
     *
     * */
    public function getPreferenciaMedico($idmedico) {


        $medico = $this
                ->getManager("ManagerMedico")
                ->get($idmedico);

        if ($medico && $medico["preferencia_idPreferencia"] != "") {

            $preferencia = parent::get($medico["preferencia_idPreferencia"]);
            $preferencia["sector"] = $this->getManager("ManagerSector")->get($medico["sector_idsector"]);

            return $preferencia;
        } else {
            return false;
        }
    }

    /**
     *  Obtiene el registro de preferencia de un medico
     *
     * */
    public function get($idmedico) {


        $medico = $this
                ->getManager("ManagerMedico")
                ->get($idmedico);

        if ($medico && $medico["preferencia_idPreferencia"] != "") {

            $preferencia = parent::get($medico["preferencia_idPreferencia"]);
            $preferencia["sector"] = $this->getManager("ManagerSector")->get($medico["sector_idsector"]);

            return $preferencia;
        } else {
            return false;
        }
    }

    /**
     *  Obtiene el registro de preferencia de un medico
     *
     * */
    public function get_basic($idPreferencia) {

        $preferencia = parent::get($idPreferencia);

        return $preferencia;
    }

}

//END_class
?>