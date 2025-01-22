<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerLogSMS extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "logsms", "idlogSMS");
        $this->default_paginate = "listado_log_sms";
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *   @version 1.0
     */

    public function insert($request) {

        $request["fecha"] = date("Y-m-d H:i:s");

        $request["numero_cel"] = str_replace(" ", "", $request["numero_cel"]);
        $request["numero_cel"] = str_replace("-", "", $request["numero_cel"]);

        $request["ultimo_envio"] = date("Y-m-d H:i:s");
        $request["estado"] = 1;

        /* No enviar SMS a Lucas Test */
        if (defined("SMS_TEST") && ($request["numero_cel"] == "+543482557191" || $request["numero_cel"] == "+543424858365" )) {
            $request["NOENVIAR"] = true;
        }

        // Hacemos la transacción directo para que no sea pérdida de tiempo"; Vamos a desactivar el buffer        
        if (!isset($request["NOENVIAR"])) {
            // descomentando lo de abajo y cambiando las key de amazon 
            //o cuando nos habiliten el servicio SNS de AWS funciona bien
            // por el momento ocupamos TWILIO
//            $AmazonSMS = new AmazonSMS();
//            $AmazonSMS->setPhoneNumber($request["numero_cel"]);
//            $AmazonSMS->setMessage(removeAcutes($request["texto"]));
//            $AmazonSMS->send();

            $TwilioSMS = new TwilioSMS();
            $TwilioSMS->send($request["numero_cel"], $request["texto"]);
        }

        $id = parent::insert($request);
        return $id;
    }

    /**
     * Método que obtiene la información de las consultas express pertenecientes a un determinado período y a un médico
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */
    public function getInfoLogSMSPeriodo($fecha_inicio, $fecha_fin, $idmedico) {
        $query = new AbstractSql();

        $query->setSelect("COUNT($this->id) as cantidad_sms, SUM(importe) as total_sms");

        $query->setFrom("$this->table");

        $query->setWhere("fecha BETWEEN '$fecha_inicio' AND '$fecha_fin'");

        $query->addAnd("medico_idmedico = $idmedico");

        $query->setGroupBy("$this->id");

        $row = $this->db->GetRow($query->getSql());

        return $row;
    }

    /**
     * Listado de registros de sms
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, $request["rows"]);
        }

        $query = new AbstractSql();
        $query->setSelect("t.idlogSMS,
                        t.fecha,
                        CASE t.dirigido
                            WHEN 'P' THEN 'Paciente'
                            WHEN 'M' THEN 'Médico' 
                            END as dirigido,
                        if (t.dirigido = 'P' , CONCAT(uwp.nombre,' ',uwp.apellido),CONCAT(uwm.nombre,' ',uwm.apellido)) as nombre_usuario,
                        if (t.dirigido = 'P', uwp.email,uwm.email) as email,
                        medico_idmedico,
                        paciente_idpaciente,
                        t.contexto,
                        t.texto,
                        t.numero_cel,
                        CASE t.estado
                            WHEN '1' THEN 'Enviado'
                            WHEN '0' THEN 'Pendiente' 
                            WHEN '99' THEN 'NO enviar' 
                        END as estado,
                        t.ultimo_envio  
                ");
        $query->setFrom("$this->table t
                 LEFT JOIN medico m ON (t.medico_idmedico=m.idmedico  AND t.dirigido='M' )
                 LEFT JOIN paciente p ON (t.paciente_idpaciente=p.idpaciente  AND t.dirigido='P')
                 LEFT JOIN usuarioweb uwm ON (  uwm.idusuarioweb = m.usuarioweb_idusuarioweb   )
                 LEFT JOIN usuarioweb uwp ON (  uwp.idusuarioweb = p.usuarioweb_idusuarioweb   )
                ");

        // Filtro

        if ($request["nombre_usuario"] != "") {
            $busqueda = cleanQuery($request["nombre_usuario"]);
            $query->addAnd("(uwm.nombre LIKE '%$busqueda%') OR  (uwm.apellido LIKE '%$busqueda%') OR (uwp.nombre LIKE '%$busqueda%') OR  (uwp.apellido LIKE '%$busqueda%')");
        }

        if ($request["numeroCelular"] != "") {
            $busqueda = cleanQuery($request["numeroCelular"]);
            $query->addAnd("(m.numeroCelular LIKE '%$busqueda%') OR (p.numeroCelular LIKE '%$busqueda%')");
        }
        if ($request["texto"] != "") {
            $busqueda = cleanQuery($request["texto"]);
            $query->addAnd("t.texto LIKE '%$busqueda%'");
        }
        if ($request["tipo_usuario"] != "") {
            $busqueda = cleanQuery($request["tipo_usuario"]);
            $query->addAnd("t.dirigido='$busqueda'");
        }
        if ($request["estado"] != "") {
            $busqueda = cleanQuery($request["estado"]);
            $query->addAnd("t.estado='$busqueda'");
        }


        if ($request["fecha"] != "") {
            $fecha = $this->sqlDate($request["fecha"]);
            $query->addAnd("t.fecha >= '{$fecha} 00:00:00' AND t.fecha <= '{$fecha} 23:59:59'");
        }



        $data = $this->getJSONList($query, array("fecha", "dirigido", "nombre_usuario", "email", "numero_cel", "contexto", "texto", "ultimo_envio", "estado"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve el detalle de log
     * @param type $id
     * @return type
     */
    public function getDetalle($id) {



        $query = new AbstractSql();
        $query->setSelect("t.idlogSMS,
                        t.fecha,
                        CASE t.dirigido
                            WHEN 'P' THEN 'Paciente'
                            WHEN 'M' THEN 'Médico' 
                            END as dirigido,
                       if (t.medico_idmedico is NULL, CONCAT(uwp.nombre,' ',uwp.apellido),CONCAT(uwm.nombre,' ',uwm.apellido)) as nombre_usuario,
                         if (t.medico_idmedico is NULL, uwp.email,uwm.email) as email,
                        medico_idmedico,
                        paciente_idpaciente,
                        t.contexto,
                        t.texto,
                        t.numero_cel,
                        CASE t.estado
                            WHEN '1' THEN 'Enviado'
                            WHEN '0' THEN 'Pendiente' 
                            WHEN '99' THEN 'NO enviar' 
                        END as estado,
                        t.intentos,
                        t.ultimo_envio  
                ");
        $query->setFrom("$this->table t
                 LEFT JOIN medico m ON (t.medico_idmedico=m.idmedico  AND t.dirigido='M' )
                 LEFT JOIN paciente p ON (t.paciente_idpaciente=p.idpaciente  AND t.dirigido='P' )
                 LEFT JOIN usuarioweb uwm ON (  uwm.idusuarioweb = m.usuarioweb_idusuarioweb   )
                 LEFT JOIN usuarioweb uwp ON (  uwp.idusuarioweb = p.usuarioweb_idusuarioweb   )
                ");
        $query->setWhere("idlogSMS=$id");
        $data = $this->getList($query);
        return $data[0];
        // Filtro
    }

    /*     * Metodo que recorre la tabla de logsms y envia cada uno que este pendiente, luego actualiza su estado
     * 
     */

    public function enviarSMSBuffer($idlogsms = null) {

        $buffer = CANTIDAD_ENVIO_SMS_SIMULTANEOS;
        if ($buffer == "") {
            $buffer = 50;
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table t");
        $query->setWhere("t.estado=0 and t.intentos<=5");
        //si viene un id particular de sms para enviar filtramos el listado solo a este
        if (!is_null($idlogsms)) {
            $query->addAnd("$this->id=$idlogsms");
        }
        $query->setOrderBy("fecha ASC");
        $query->setLimit("0,$buffer");

        $cola_sms = $this->getList($query);
        if (COUNT($cola_sms) > 0) {

            $exito = true;
            $cant_enviados = 0;
            $cant_error = 0;
            foreach ($cola_sms as $sms) {
                $smsc = XSMS::getInstance();
                try {
                    // Enviar SMS
                    $smsc->addNumero($sms["numero_cel"]);
                    $smsc->setMensaje($sms["texto"]);


                    //actualizamos los datos del registro del mail
                    $record["ultimo_envio"] = date("Y-m-d H:i:s");

                    $record["intentos"] = (int) $sms["intentos"] + 1;
                    //$rdo = $smsc->enviar();
                    $rdo = true;
                } catch (Exception $e) {
                    echo 'Se produjo un Error ' . $e->getCode() . ': ' . $e->getMessage();
                }



                if (!$rdo) {
                    $record["estado"] = 0;
                    $cant_error++;
                    $exito = false;
                } else {
                    $record["estado"] = 1;
                    $cant_enviados++;
                }
                parent::update($record, $sms["$this->id"]);
            }

            if ($exito) {
                echo "Se han enviado $cant_enviados sms en cola";
            } else {
                echo "Ha ocurrido un error al enviar $cant_error sms";
            }
        } else {
            echo "No hay sms en cola para ser enviados";
        }
    }

}

//END_class
?>