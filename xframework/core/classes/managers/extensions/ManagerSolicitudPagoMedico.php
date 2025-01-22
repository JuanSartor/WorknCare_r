<?php

/**
 * 	Manager de De las solicitud de los pagos de los médicos
 *
 * 	@author UTN
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerSolicitudPagoMedico extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "solicitudpagomedico", "idsolicitudPagoMedico");
        $this->default_paginate = "solicitud_pago_list";
    }

    /**
     * Método que realiza el procesamiento de la solicitud del pago para el médico.
     * 
     * @param type $request
     */
    public function processSolicitudPagoMedico($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        //verificamos que el perido de pago solicitado este disponible y corresponda al medico
        $periodo_pago = $this->getManager("ManagerPeriodoPago")->get($request["idperiodoPago"]);
        if ($periodo_pago["medico_idmedico"] != $idmedico || $periodo_pago["status_solicitud_pago"] != 1) {
            $this->setMsg(["msg" => "No se pudo recuperar el periodo de pago", "result" => false]);
            return false;
        }

        //verificar que no existe una solicitud de pago
        $solicitud_pago = $this->getByField("periodoPago_idperiodoPago", $request["idperiodoPago"]);
        if ($solicitud_pago) {
            $this->setMsg(["msg" => "Ya se ha realizado la solicitud de pago", "result" => false]);
            return false;
        }

        //informacion comercial del medico al momento de solicitar el pago
        $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");
        $informacion_comercial = $ManagerInformacionComercialMedico->getByField("medico_idmedico", $idmedico);

        unset($informacion_comercial["idinformacion_comercial_medico"]);
        $informacion_comercial["fechaSolicitudPago"] = date("Y-m-d");
        //$informacion_comercial["medicoFactura_idmedicoFactura"] = $request["idmedicoFactura"];
        $informacion_comercial["periodoPago_idperiodoPago"] = $request["idperiodoPago"];


        $this->db->StartTrans();

        $id = parent::process($informacion_comercial);


        if (!$id) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se produjo un error al solicitar el pago", "result" => false]);
            return false;
        }

        /**
         * Se procesó la solicitud de pago con éxito.
         * Ahora deberá ser procesada por el administrador, en el back end
         */
        $medico = $this->getManager("ManagerMedico")->get($idmedico);
        $smarty = SmartySingleton::getInstance();
        $smarty->assign("medico", $medico);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/nueva_solicitud_pago.tpl"));
        $mEmail->setSubject(sprintf("WorknCare: Nouvelle demande de paiement de %s %s %s", $medico["tituloprofesional"], $medico["nombre"], $medico["apellido"]));

        $mEmail->setFromName($medico["nombre"] . " " . $medico["apellido"]);
        $mEmail->AddReplyTo($medico["email"], $medico["tituloprofesional"] . " " . $medico["nombre"] . " " . $medico["apellido"]);

        $mEmail->addTo(DEFAULT_PAGOS_EMAIL);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->send();
        //Debo enviar por JSON, los datos para actualizar en el MODAL

        $nombre_corto_mes = getNombreCortoMes();
        $fecha_format = date("d") . " $nombre_corto_mes " . date("Y");
        $this->setMsg(["result" => true, "msg" => "La solicitud fue procesada con éxito", "fecha_solicitud" => $fecha_format, "numero_solicitud" => $id]);

        // <-- LOG
        $log["data"] = "Confirm instruction to transfer amount to personnal bank acocunt";
        $log["page"] = "My account";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Transfer credit available";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 

        $this->db->CompleteTrans();

        return $id;
    }

    /**
     * Método que devulve el listado de las solicitudes de pago x periodo de los medicos
     * @param type $idpaginate
     * @param type $request
     * @return type
     */
    public function getListadoJSON($request, $idpaginate = NULL) {
        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }


        $query = new AbstractSql();
        $query->setSelect("
                        spm.$this->id,
                            DATE_FORMAT(spm.fechaSolicitudPago,'%d/%m/%Y') as fechaSolicitudPago_format,
                            CONCAT(uw.nombre,  ' ', uw.apellido) as nombre_medico,
                            b.nombre_banco,
                            CONCAT(pp.anio, ' - ', pp.mes) as date_periodo,
                            m.CUIT,
                            CASE 
                                WHEN spm.metodo_cobro = 1 THEN 'Transferencia Bancaria' 
                                ELSE 'Cheque'  END as metodo_cobro_format,
                            CASE
                                WHEN spm.estado = 0 THEN 'En proceso'
                                WHEN spm.estado = 1 THEN 'Pagado' 
                                WHEN spm.estado = 2 THEN 'Retenido' 
                                END as estado_pago,
                            (IFNULL(importe_consulta_express,0) + IFNULL(importe_videoconsulta,0) - IFNULL(importe_comision_consulta_express,0) - IFNULL(importe_comision_videoconsulta,0)) as importePeriodo,
                             IFNULL(importe_comision_consulta_express,0) + IFNULL(importe_comision_videoconsulta,0) as comisionPeriodo


                    ");
        $query->setFrom("
                solicitudpagomedico spm 
                    INNER JOIN periodopago pp ON (pp.idperiodoPago = spm.periodoPago_idperiodoPago)
                    INNER JOIN medico m ON (m.idmedico = pp.medico_idmedico)
                    INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                    LEFT JOIN banco b ON (spm.banco_idbanco = b.idbanco)
            ");


        // Filtro
        if ($request["fechaSolicitudPago"] != "") {

            $rdo = $this->sqlDate($request["fechaSolicitudPago"], "-", true);

            $query->addAnd("spm.fechaSolicitudPago = '$rdo'");
        }

        if ($request["nombre_medico"] != "") {

            $rdo = cleanQuery($request["nombre_medico"]);

            $query->addAnd("CONCAT(uw.nombre,  ' ', uw.apellido) LIKE '%$rdo%'");
        }

        if ($request["nombre_banco"] != "") {

            $rdo = cleanQuery($request["nombre_banco"]);

            $query->addAnd("b.nombre_banco LIKE '%$rdo%'");
        }


        if ($request["date_periodo"] != "") {

            $rdo = cleanQuery($request["date_periodo"]);

            $query->addAnd("CONCAT(pp.anio, ' - ', pp.mes) LIKE '%$rdo%'");
        }
        if ($request["estado"] != "") {

            $rdo = cleanQuery($request["estado"]);

            $query->addAnd("spm.estado = $rdo");
        }


        $data = $this->getJSONList($query, array("fechaSolicitudPago_format", "nombre_medico", "CUIT", "metodo_cobro_format", "nombre_banco", "date_periodo", "importePeriodo", "comisionPeriodo", "estado_pago"), $request, $idpaginate);

        $data = json_decode($data);




        if ($data->rows) {
            /*  $query1 = new AbstractSql();
              $query1->setSelect("
              SUM(t.importePeriodo) AS total_solicitudes
              ");
              $query1->setFrom("(" . $query->getSql() . ") t");
              $total_solicitudes = $this
              ->db
              ->GetOne($query1->getSql()); */



            //pagado
            $query1 = new AbstractSql();
            $query1->setSelect("
                IFNULL(SUM(t.importePeriodo),0) AS total_pagado
              ");
            $query1->setFrom("(" . $query->getSql() . ") t");
            $query1->setWhere("t.estado_pago='Pagado'");
            $total_pagado = $this
                    ->db
                    ->GetOne($query1->getSql());
            //Retenido
            $query2 = new AbstractSql();
            $query2->setSelect("
              IFNULL(SUM(t.importePeriodo),0) AS total_retenido
              ");
            $query2->setFrom("(" . $query->getSql() . ") t");
            $query2->setWhere("t.estado_pago='Retenido'");
            $total_retenido = $this
                    ->db
                    ->GetOne($query2->getSql());
            //En Proceso
            $query3 = new AbstractSql();
            $query3->setSelect("
                IFNULL(SUM(t.importePeriodo),0) AS total_pendiente
              ");
            $query3->setFrom("(" . $query->getSql() . ") t");
            $query3->setWhere("t.estado_pago='En proceso'");
            $total_pendiente = $this
                    ->db
                    ->GetOne($query3->getSql());

            //Comision
            $query4 = new AbstractSql();
            $query4->setSelect("
                IFNULL(SUM(t.comisionPeriodo),0) AS total_comisiones
              ");
            $query4->setFrom("(" . $query->getSql() . ") t");

            $total_comisiones = $this
                    ->db
                    ->GetOne($query4->getSql());

            $data->total_solicitudes = $total_pagado + $total_pendiente + $total_retenido;
            $data->total_pagado = $total_pagado;
            $data->total_pendiente = $total_pendiente;
            $data->total_retenido = $total_retenido;
            $data->total_comisiones = $total_comisiones;
        } else {
            $data->total_solicitudes = 0.0;
            $data->total_pagado = 0.0;
            $data->total_pendiente = 0.0;
            $data->total_retenido = 0.00;
            $data->total_comisiones = 0.00;
        }

        return json_encode($data);
    }

    /**
     * M étodo que devulve el listado de las recaudaciones x periodo de los medicos
     * @param type $idpaginate
     * @param type $request
     * @return type
     */
    public function getListadoRecaudacionesJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }


        $query = new AbstractSql();
        $query->setSelect("
                            pp.idperiodoPago as $this->id,
                            IFNULL(DATE_FORMAT(spm.fechaSolicitudPago,'%d/%m/%Y'),'-') as fechaSolicitudPago_format,
                            CONCAT(uw.nombre,  ' ', uw.apellido) as nombre_medico,
                            b.nombre_banco,
                            CONCAT(pp.anio, ' - ', pp.mes) as date_periodo,
                            m.CUIT,
                            CASE 
                                WHEN spm.metodo_cobro = 1 THEN 'Transferencia Bancaria' 
                                ELSE 'Transferencia Bancaria'  END as metodo_cobro_format,
                            CASE
                                WHEN spm.estado = 0 THEN 'En proceso'
                                WHEN spm.estado = 1 THEN 'Pagado' 
                                WHEN spm.estado = 2 THEN 'Retenido' 
                                WHEN spm.estado is null THEN 'Pendiente'
                            END as estado_pago,
                            (IFNULL(importe_consulta_express,0) + IFNULL(importe_videoconsulta,0) - IFNULL(importe_comision_consulta_express,0) - IFNULL(importe_comision_videoconsulta,0)) as importePeriodo,
                            IFNULL(importe_comision_consulta_express,0) + IFNULL(importe_comision_videoconsulta,0) as comisionPeriodo


                    ");
        $query->setFrom("
                    periodopago pp
                    LEFT JOIN  solicitudpagomedico spm  ON (pp.idperiodoPago = spm.periodoPago_idperiodoPago)
                    INNER JOIN medico m ON (m.idmedico = pp.medico_idmedico)
                    INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                    LEFT JOIN banco b ON (spm.banco_idbanco = b.idbanco)
            ");


        // Filtro
        $query->setWhere("(IFNULL(importe_consulta_express,0) + IFNULL(importe_videoconsulta,0) - IFNULL(importe_comision_consulta_express,0) - IFNULL(importe_comision_videoconsulta,0))>0");

        if ($request["nombre_medico"] != "") {

            $rdo = cleanQuery($request["nombre_medico"]);

            $query->addAnd("CONCAT(uw.nombre,  ' ', uw.apellido) LIKE '%$rdo%'");
        }


        if ($request["date_periodo_desde"] != "") {

            $rdo = trim(cleanQuery($request["date_periodo_desde"]));

            list($anio_desde, $mes_desde) = explode(" - ", $rdo);

            $query->addAnd("(pp.anio > $anio_desde OR (pp.anio = $anio_desde AND pp.mes >=$mes_desde) )");
        }

        if ($request["date_periodo_hasta"] != "") {

            $rdo = trim(cleanQuery($request["date_periodo_hasta"]));

            list($anio_hasta, $mes_hasta) = explode(" - ", $rdo);

            $query->addAnd("(pp.anio < $anio_hasta OR (pp.anio = $anio_hasta AND pp.mes <=$mes_hasta) )");
        }


        if ($request["estado"] != "") {

            $rdo = cleanQuery($request["estado"]);
            if ($rdo == -1) {
                $query->addAnd("spm.estado is NULL");
            } else {
                $query->addAnd("spm.estado = $rdo");
            }
        }

        $query->setOrderBy("pp.anio desc,pp.mes desc,nombre_medico desc");



        $data = $this->getJSONList($query, array("nombre_medico", "CUIT", "metodo_cobro_format", "nombre_banco", "date_periodo", "importePeriodo", "comisionPeriodo", "fechaSolicitudPago_format", "estado_pago"), $request, $idpaginate);

        $data = json_decode($data);




        if ($data->rows) {
            /*  $query1 = new AbstractSql();
              $query1->setSelect("
              SUM(t.importePeriodo) AS total_solicitudes
              ");
              $query1->setFrom("(" . $query->getSql() . ") t");
              $total_solicitudes = $this
              ->db
              ->GetOne($query1->getSql()); */



            //pagado
            $query1 = new AbstractSql();
            $query1->setSelect("
                IFNULL(SUM(t.importePeriodo),0) AS total_pagado
              ");
            $query1->setFrom("(" . $query->getSql() . ") t");
            $query1->setWhere("t.estado_pago='Pagado'");
            $total_pagado = $this
                    ->db
                    ->GetOne($query1->getSql());
            //Retenido
            $query2 = new AbstractSql();
            $query2->setSelect("
              IFNULL(SUM(t.importePeriodo),0) AS total_retenido
              ");
            $query2->setFrom("(" . $query->getSql() . ") t");
            $query2->setWhere("t.estado_pago='Retenido'");
            $total_retenido = $this
                    ->db
                    ->GetOne($query2->getSql());
            //En Proceso
            $query3 = new AbstractSql();
            $query3->setSelect("
                IFNULL(SUM(t.importePeriodo),0) AS total_recaudacion
              ");
            $query3->setFrom("(" . $query->getSql() . ") t");

            $total_a_pagar = $this
                    ->db
                    ->GetOne($query3->getSql());

            //Comision
            $query4 = new AbstractSql();
            $query4->setSelect("
                IFNULL(SUM(t.comisionPeriodo),0) AS total_comisiones
              ");
            $query4->setFrom("(" . $query->getSql() . ") t");

            $total_comisiones = $this
                    ->db
                    ->GetOne($query4->getSql());

            $data->total_recaudacion = (float) $total_a_pagar + $total_comisiones;
            $data->total_pagado = (float) $total_pagado;
            $data->total_pendiente = (float) $total_a_pagar - (float) $total_pagado - (float) $total_retenido;
            $data->total_retenido = (float) $total_retenido;
            $data->total_comisiones = (float) $total_comisiones;
        } else {
            $data->total_recaudacion = (float) 0.0;
            $data->total_pagado = (float) 0.0;
            $data->total_pendiente = (float) 0.0;
            $data->total_retenido = (float) 0.00;
            $data->total_comisiones = (float) 0.00;
        }

        return json_encode($data);
    }

    /**
     * Sobreescritura del get, para mostrar mas datos
     * @param type $id
     * @param type $all
     * @return type
     */
    public function getSolicitud($id, $all = false) {
        $rdo = parent::get($id);


        if ($rdo) {
            if ($all) {
                $ManagerBanco = $this->getManager("ManagerBanco");
                $rdo["banco"] = $ManagerBanco->get($rdo["banco_idbanco"]);

                $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
                $periodo_pago = $ManagerPeriodoPago->get($rdo["periodoPago_idperiodoPago"]);
                $rdo["periodo_pago"] = $periodo_pago;
                $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");
                $rdo["informacion_comercial"] = $ManagerInformacionComercialMedico->getInformacionComercialMedico($periodo_pago["medico_idmedico"]);

                return $rdo;
            } else {
                return $rdo;
            }
        } else {
            return $rdo;
        }
    }

    /**
     * Mpétodo que actualiza unicamente los estados de la solicitud de pago por parte del médico
     * @param type $request
     * @return boolean
     */
    public function processFromAdmin($request) {
        //verificamos que venga la fecha de pago, sino elegimo la fecha actual
        if ($request["fechaPago"] == "") {
            $request["fechaPago"] = date("Y-m-d");
        } else {
            $request["fechaPago"] = $this->sqlDate($request["fechaPago"], '-', true);
        }


        $id = $request[$this->id];

        $solicitud = $this->get($id);



        //si se cambia el estado a pagado debemos adjuntar el archivo de comprobante
        foreach ($request["hash"] as $k => $hash) {

            $file = $_SESSION[$hash];

            $path_tmp = path_files("temp/" . $file["name"]);

            $path = path_entity_files("comisiones_solicitud_pago/$id/");


            if (!is_dir($path)) {
                $Dir = new Dir($path);
                $Dir->chmod(0777);
            }

            if (file_exists($path_tmp)) {
                $new_path = path_entity_files("comisiones_solicitud_pago/{$id}/{$id}.pdf");
                if (file_exists($new_path) && file_exists($path_tmp)) {
                    unlink($new_path);
                }

                rename($path_tmp, $new_path);
                $comprobante = parent::update(["posee_file" => 1], $id);
                unlink($path_tmp);
                if (!$comprobante) {
                    $this->setMsg(["result" => false, "msg" => "No se pudo adjuntar el comprobante de pago"]);
                    return false;
                }
            }
        }


        //actualizamos el estado
        $rdo = parent::update(array("estado" => $request["estado"], "fechaPago" => $request["fechaPago"]), $request[$this->id]);

        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "La solicitud de pago ha sido procesada con exito"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo cambiar el estado de la solicitud de pago del médico"]);
            return false;
        }
    }

    /*     * Metodo que retorna el listado paginado de las solicitudes de pago de los periodos hechas por el medico en sesion
     * 
     */

    public function getListadoPaginadoSolicitudesPagoMedico($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();
        $query->setSelect("*,
                (IFNULL(importe_consulta_express,0) + IFNULL(importe_videoconsulta,0) - IFNULL(importe_comision_consulta_express,0) - IFNULL(importe_comision_videoconsulta,0)) as importePeriodo,
                (IFNULL(importe_comision_consulta_express,0) + IFNULL(importe_comision_videoconsulta,0)) as importe_comisiones 
                ");

        $query->setFrom("$this->table t inner join periodopago p on (t.periodoPago_idperiodoPago=p.idperiodoPago)");
        $query->setWhere("p.medico_idmedico=$idmedico");
        $query->setOrderBy("t.fechaSolicitudPago DESC");

        $listado = $this->getListPaginado($query, $idpaginate);
        if ($listado["rows"] && count($listado["rows"]) > 0) {
            foreach ($listado["rows"] as $key => $pago) {
                $nombre_mes = getNombreMes($pago["mes"]);
                $listado["rows"][$key]["periodo_format"] = $nombre_mes . " " . $pago["anio"];
                $listado["rows"][$key]["fecha_solicitud_format"] = fechaToString($pago["fechaSolicitudPago"]);
                $listado["rows"][$key]["hash"] = base64_encode($pago["idsolicitudPagoMedico"]);
            }
        }
        return $listado;
    }

    /**
     *
     *  Combo de los estados que pueden tener las solicitudes de pagos
     *
     * */
    public function getComboEstadoSolicitudPagoMedico() {

        return array(
            0 => "En Proceso",
            1 => "Pagado",
            2 => "Rechazado"
        );
    }

}

//END_class 
?>