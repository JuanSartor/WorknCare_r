<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los pacientes que pertenecen a un grupo familiar
 *    No son usuarios web.
 *
 */
class ManagerPeriodoPago extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "periodopago", "idperiodoPago");
    }

    /**
     * Obtención de los períodos para el combo
     * @return type
     */
    public function getCombo($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        $query = new AbstractSql();
        $query->setSelect("$this->id, 
                 CASE mes
                  WHEN 1 THEN CONCAT('Janvier',' ',anio)
                  WHEN 2 THEN CONCAT('Février',' ',anio)
                  WHEN 3 THEN CONCAT('Mars',' ',anio)
                  WHEN 4 THEN CONCAT('Avril',' ',anio)
                  WHEN 5 THEN CONCAT('Mai',' ',anio)
                  WHEN 6 THEN CONCAT('Juin',' ',anio)
                  WHEN 7 THEN CONCAT('Juillet',' ',anio)
                  WHEN 8 THEN CONCAT('Août',' ',anio)
                  WHEN 9 THEN CONCAT('Septembre',' ',anio)
                  WHEN 10 THEN CONCAT('Octobre',' ',anio)
                  WHEN 11 THEN CONCAT('Novembre',' ',anio)
                  WHEN 12 THEN CONCAT('Décembre',' ',anio)
                  END 
                  "
        );
        $query->setFrom("$this->table");
        if (!is_null($idmedico)) {
            $query->setWhere("medico_idmedico = $idmedico");
        }
        $query->setOrderBy("anio DESC, mes DESC");
        $query->setLimit("0,12");
        $rdo = $this->getComboBox($query, false);

        return $rdo;
    }

    /**
     * Obtención de los períodos para el combo de busqueda
     * @return type
     */
    public function getListPeriodos() {


        $query = new AbstractSql();
        $query->setSelect(" 	
            CONCAT(anio , ' - ', mes) as id,
            CASE mes 
            WHEN 1 THEN  CONCAT('Janvier', ' ', anio)
            WHEN 2 THEN CONCAT('Février', ' ', anio)
            WHEN 3 THEN CONCAT('Mars', ' ', anio)
            WHEN 4 THEN CONCAT('Avril', ' ', anio)
            WHEN 5 THEN CONCAT('Mai', ' ', anio)
            WHEN 6 THEN CONCAT('Juin', ' ', anio)
            WHEN 7 THEN CONCAT('Juillet', ' ', anio)
            WHEN 8 THEN CONCAT('Août', ' ', anio)
            WHEN 9 THEN CONCAT('Septembre', ' ', anio)
            WHEN 10 THEN CONCAT('Octobre', ' ', anio)
            WHEN 11 THEN CONCAT('Novembre', ' ', anio)
            WHEN 12 THEN CONCAT('Décembre', ' ', anio)
            END  as descripcion
                  "
        );
        $query->setFrom("$this->table");

        $query->setOrderBy("anio DESC, mes DESC");
        $query->setGroupBy("id");
        $rdo = $this->getList($query);

        return $rdo;
    }

    /**
     * Metodo que devuelve un listado con un resumen de las consultas express y videoconsultas realizadas por los pacientes y los montos de las mismas
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoConsultasRecaudacionesJSON($request, $idpaginate = null) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 50);
        }

        $queryVC = new AbstractSql();
        $queryVC->setSelect("CONCAT(uw_m.nombre, ' ', uw_m.apellido) AS nombre_medico,
                        IF (
				pf.idpacienteGrupoFamiliar IS NULL,
				CONCAT(uw.nombre, ' ', uw.apellido),
				CONCAT(pf.nombre, ' ', pf.apellido)
			) AS nombre_paciente,
                        'Video Consulta' as tipo_consulta,
                        CONCAT('Nº ',vc.numeroVideoConsulta) as numero_consulta,
                        DATE_FORMAT(fecha_inicio,'%d-%m-%Y %H:%i') as fecha_str,
                        fecha_inicio,
                           ev.idestadoVideoConsulta as idestado,
                        ev.estadoVideoConsulta as estado,
                        FORMAT(IFNULL(vc.precio_tarifa,0),2) as importe,
                          FORMAT(IFNULL(vc.comision_doctor_plus,0),2) as comision,
                          FORMAT(IFNULL(vc.precio_tarifa_prestador,0),2) as importe_prestador,
                          FORMAT(IFNULL(vc.comision_prestador,0),2) as comision_prestador");
        $queryVC->setFrom("videoconsulta vc
                           INNER JOIN medico m ON (vc.medico_idmedico = m.idmedico)
                            INNER JOIN usuarioweb uw_m ON (m.usuarioweb_idusuarioweb = uw_m.idusuarioweb)
                            LEFT JOIN paciente p ON vc.paciente_idpaciente = p.idpaciente
                            LEFT JOIN usuarioweb uw ON p.usuarioweb_idusuarioweb = uw.idusuarioweb
                            LEFT JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                            INNER JOIN estadovideoconsulta ev ON (vc.estadoVideoConsulta_idestadoVideoConsulta=ev.idestadoVideoConsulta AND ev.idestadoVideoConsulta<>6)");
        $queryVC->setGroupBy("vc.idvideoconsulta");
        $queryCE = new AbstractSql();
        $queryCE->setSelect("
                        CONCAT(uw_m.nombre, ' ', uw_m.apellido) AS nombre_medico,
                        IF (
				pf.idpacienteGrupoFamiliar IS NULL,
				CONCAT(uw.nombre, ' ', uw.apellido),
				CONCAT(pf.nombre, ' ', pf.apellido)
			) AS nombre_paciente,
                        'Consulta Express' as tipo_consulta,
                        CONCAT('Nº ',ce.numeroConsultaExpress) as numero_consulta,
                        DATE_FORMAT(fecha_inicio,'%d-%m-%Y %H:%i') as fecha_str,
                        fecha_inicio,
                        ece.idestadoConsultaExpress as idestado,
                        ece.estadoConsultaExpress as estado,
                         FORMAT(IFNULL(ce.precio_tarifa,0),2) as importe,
                         FORMAT(IFNULL(ce.comision_doctor_plus,0),2) as comision,
                         FORMAT(IFNULL(ce.precio_tarifa_prestador,0),2) as importe_prestador,
                         FORMAT(IFNULL(ce.comision_prestador,0),2) as comision_prestador");
        $queryCE->setFrom("consultaexpress ce
                        INNER JOIN medico m ON (ce.medico_idmedico = m.idmedico)
                        INNER JOIN usuarioweb uw_m ON (m.usuarioweb_idusuarioweb = uw_m.idusuarioweb)
                        LEFT JOIN paciente p ON ce.paciente_idpaciente = p.idpaciente
                        LEFT JOIN usuarioweb uw ON p.usuarioweb_idusuarioweb = uw.idusuarioweb
                        LEFT JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                        INNER JOIN estadoconsultaexpress ece ON (ce.estadoConsultaExpress_idestadoConsultaExpress=ece.idestadoConsultaExpress AND ece.idestadoConsultaExpress<>6)");
        $queryCE->setGroupBy("ce.idconsultaExpress");
        $query = new AbstractSql();

        $query->setSelect("t.*");
        $query->setFrom("(({$queryVC->getSql()}) UNION ({$queryCE->getSql()})) as t");


        if ($request["nombre_medico"] != "") {
            $rdo = cleanQuery($request["nombre_medico"]);
            $query->addAnd("nombre_medico LIKE '%$rdo%'");
        }
        if ($request["nombre_paciente"] != "") {
            $rdo = cleanQuery($request["nombre_paciente"]);
            $query->addAnd("nombre_paciente LIKE '%$rdo%'");
        }

        if ($request["date_periodo_desde"] != "") {

            $rdo = trim(cleanQuery($request["date_periodo_desde"]));

            list($anio_desde, $mes_desde) = explode(" - ", $rdo);

            $query->addAnd("fecha_inicio >= '$anio_desde-$mes_desde-01'");
        }

        if ($request["date_periodo_hasta"] != "") {

            $rdo = trim(cleanQuery($request["date_periodo_hasta"]));

            list($anio_hasta, $mes_hasta) = explode(" - ", $rdo);
            $ultimo_dia = getCantidadDiasMes($mes_hasta);
            $query->addAnd("fecha_inicio <= '$anio_hasta-$mes_hasta-$ultimo_dia'");
        }

        if ($request["tipo_consulta"] != "") {

            $rdo = cleanQuery($request["tipo_consulta"]);
            if ($rdo == 1) {
                $query->addAnd("tipo_consulta = 'Consulta Express'");
            }
            if ($rdo == 2) {
                $query->addAnd("tipo_consulta = 'Video Consulta'");
            }
        }

        if ($request["estado"] != "") {

            $rdo = cleanQuery($request["estado"]);

            $query->addAnd("idestado = '$rdo'");
        }




        $data = $this->getJSONList($query, array("nombre_medico", "nombre_paciente", "tipo_consulta", "numero_consulta", "fecha_str", "importe", "comision", "importe_prestador", "comision_prestador", "estado"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que retorna el período de pago de un determinado médico y un determinado período
     * @param type $mes
     * @param type $anio
     * @param type $idmedico
     * @return type
     */
    public function getXPeriodo($mes, $anio, $idmedico) {
        $mes = (int) $mes;
        $query = new AbstractSql();

        $query->setSelect("*, 
                            (total_consulta_express + total_videoconsulta + total_sms) as total_periodo,
                            (importe_consulta_express + importe_videoconsulta + importe_sms) as importe_total_periodo");

        $query->setFrom("$this->table");

        $query->setWhere("mes = $mes");

        $query->addAnd("anio = $anio");

        $query->addAnd("medico_idmedico = $idmedico");

        return $this->db->GetRow($query->getSql());
    }

    /*     * Metodo que retorna la informacion y totales de un periodo de pago del medico
     * 
     * @param type $id
     * @return boolean
     */

    public function get($id) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $periodo = parent::get($id);
        //recalculamos los importes de la VC y la CE realizadas en el periodo
        $this->actualizarValoresFromCierreCE($idmedico, $periodo["mes"], $periodo["anio"]);
        $this->actualizarValoresFromCierreVC($idmedico, $periodo["mes"], $periodo["anio"]);


        $query = new AbstractSql();
        $query->setSelect("idperiodoPago,
                            medico_idmedico, 
                            anio,
                            mes,
                            total_consulta_express,
                            total_videoconsulta,
                            total_sms,
                            status_solicitud_pago,
                            IFNULL(importe_consulta_express,0) as importe_consulta_express,
                            IFNULL(importe_videoconsulta,0) as  importe_videoconsulta,
                            IFNULL(importe_sms,0) as importe_sms,
                            IFNULL(importe_comision_consulta_express,0) as importe_comision_consulta_express,
                            IFNULL(importe_comision_videoconsulta,0) as importe_comision_videoconsulta,
                            (total_consulta_express + total_videoconsulta) as total_periodo,
                            (IFNULL(importe_comision_consulta_express,0) + IFNULL(importe_comision_videoconsulta,0)) as importe_comisiones, 
                            (IFNULL(importe_consulta_express,0) + IFNULL(importe_videoconsulta,0) - IFNULL(importe_comision_consulta_express,0) - IFNULL(importe_comision_videoconsulta,0)) as importePeriodo
                             ");
        $query->setFrom("$this->table");
        $query->setWhere("$this->id = $id");

        $execute = $this->db->Execute($query->getSql());
        if ($execute) {
            return $execute->FetchRow();
        } else {
            return false;
        }
    }

    /**
     * Obtiene el último período de pago correspondiente al médico
     * @param type $idmedico
     */
    public function getLast($idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        $query = new AbstractSql();
        $query->setSelect("*, CONCAT(anio, ' - ', mes), 
                                (total_consulta_express + total_videoconsulta + total_sms) as total_periodo, 
                                (importe_consulta_express + importe_videoconsulta + importe_sms) as importe_total_periodo");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico = $idmedico");
        $query->setOrderBy("anio DESC, mes DESC");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Método que realiza el insert del período de pago del médico
     * Este método se correrá el primer minuto del primer día del mes.
     * @param type $idmedico
     */
    public function insertPeriodoPagoMedico($idmedico = null) {
        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        //Obtengo el período de pago anterior
        $periodo_pago = $this->getLast($idmedico);

        $mes = date("m");
        $anio = date("Y");
        $this->db->StartTrans();
        /**
         * Si hay un período anterior y el status no está finalizado 
         * Realizo actualización
         */
        if ($periodo_pago && $periodo_pago["status_solicitud_pago"] == 0) {

            //Si no es de este mes la inserción del período de pago
            if ($periodo_pago["mes"] != $mes || $periodo_pago["anio"] != $anio) {

                $periodo_pago["status_solicitud_pago"] = 1;

                //ültimo día del mes del período de pago
                $fecha_fin_periodo = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
                $fecha_inicio_periodo = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));

                //Inserción del período de pago, comienzo a buscar los datos
                $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
                $info_consulta_express = $ManagerConsultaExpress->getInfoConsultaExpressPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);

                if ($info_consulta_express) {
                    $periodo_pago["total_consulta_express"] = $info_consulta_express["cantidad_consultas_express"];
                    $periodo_pago["importe_consulta_express"] = $info_consulta_express["monto_tarifa"];
                    $periodo_pago["importe_comision_consulta_express"] = $info_consulta_express["monto_comision_doctor_plus"];
                }

                //Inserción del período de pago, comienzo a buscar los datos
                $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                $info_videoconsulta = $ManagerVideoConsulta->getInfoVideoConsultaPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);


                if ($info_videoconsulta) {
                    $periodo_pago["total_videoconsulta"] = $info_videoconsulta["cantidad_videoconsulta"];
                    $periodo_pago["importe_videoconsulta"] = $info_videoconsulta["monto_tarifa"];
                    $periodo_pago["importe_comision_videoconsulta"] = $info_videoconsulta["monto_comision_doctor_plus"];
                }




                $update = parent::update($periodo_pago, $periodo_pago[$this->id]);
                if (!$update) {
                    $this->setMsg(["msg" => "Error. No se pudo modificar el período de pago anterior", "result" => false]);
                    $this->db->FailTrans();
                    return false;
                }
            }
        }

        $is_exist_periodo = $this->getXPeriodo($mes, $anio, $idmedico);

        if (!$is_exist_periodo) {
            //Inserto el nuevo periodo
            $insert_nuevo_periodo = [
                "mes" => $mes,
                "anio" => $anio,
                "medico_idmedico" => $idmedico,
                "status_solicitud_pago" => 0
            ];

            $insert = parent::insert($insert_nuevo_periodo);

            if ($insert) {
                $this->setMsg(["msg" => "El período de pago fue creado con éxito", "result" => false]);
//              $this->db->FailTrans();
                $this->db->CompleteTrans();
                return $insert;
            } else {
                $this->setMsg(["msg" => "Error. No se pudo crear el período de pago", "result" => false]);
                $this->db->FailTrans();
                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. Ya está creado ese registro de pago para ese periodo", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
    }

    /**
     * Método que corre el cron todos los 1 de cada mes para la generación de los períodos de pago, 
     * además se cierran los períodos actuales
     * @return boolean
     */
    public function cronCreacionPeriodoPago() {
        $ManagerMedico = $this->getManager("ManagerMedico");
        $listado_medicos = $ManagerMedico->getListAllMedicos();

        if ($listado_medicos && count($listado_medicos) > 0) {
            foreach ($listado_medicos as $key => $medico) {
                $this->insertPeriodoPagoMedico($medico["idmedico"]);
            }
            return true;
        } else {
            return false;
        }
    }

    /**
     * Método utilizado para actualizar los valores del periodo de pago  cuando se cierra una consulta express
     * @param type $request
     */
    public function actualizarValoresFromCierreCE($idmedico = null, $mes = null, $anio = null) {
        if (CONTROLLER == "medico" && is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        if (is_null($mes) && is_null($anio)) {
            $mes = date("m");
            $anio = date("Y");
        }


        $periodo_pago = $this->getXPeriodo($mes, $anio, $idmedico);
        if (!$periodo_pago) {
            //si no existe lo creamos
            $this->insertPeriodoPagoMedico($idmedico);
            $periodo_pago = $this->getXPeriodo($mes, $anio, $idmedico);
        }

        //ültimo día del mes del período de pago
        $fecha_fin_periodo = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
        $fecha_inicio_periodo = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));

        //Inserción del período de pago, comienzo a buscar los datos
        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
        $info_consulta_express = $ManagerConsultaExpress->getInfoConsultaExpressPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);

        if ($info_consulta_express) {
            $periodo_pago["total_consulta_express"] = $info_consulta_express["cantidad_consultas_express"];
            $periodo_pago["importe_consulta_express"] = $info_consulta_express["monto_tarifa"];
            $periodo_pago["importe_comision_consulta_express"] = $info_consulta_express["monto_comision_doctor_plus"];
        }

        $update = parent::update($periodo_pago, $periodo_pago[$this->id]);
        //$acreditar_consultaexpress_finalizadas = $ManagerConsultaExpress->acreditarConsultaExpressFinalizadaPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);
        if ($update) {
            return true;
        }
    }

    /**
     * Método utilizado para actualizar los valores del periodo de pago  cuando se cierra una consulta express
     * La videoconsulta puede ser cerrada por el medico cuando escribe las concluisones medicas
     * o por el paciente cuando cancela una consulta pendiente de finalizacion
     * @param type $idmedico para el medico se obtiene de sesion, para el paciente se pasa por parametro desde la videoconsulta que se finaliza
     */
    public function actualizarValoresFromCierreVC($idmedico = null, $mes = null, $anio = null) {

        if (CONTROLLER == "medico" && is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        }

        if (is_null($mes) && is_null($anio)) {
            $mes = date("m");
            $anio = date("Y");
        }


        $mes = date("m");
        $anio = date("Y");

        $periodo_pago = $this->getXPeriodo($mes, $anio, $idmedico);
        if (!$periodo_pago) {
            //si no existe lo creamos
            $this->insertPeriodoPagoMedico($idmedico);
            $periodo_pago = $this->getXPeriodo($mes, $anio, $idmedico);
        }



        //ültimo día del mes del período de pago
        $fecha_fin_periodo = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
        $fecha_inicio_periodo = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));

        //Inserción del período de pago, comienzo a buscar los datos
        $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
        $info_videoconsulta = $ManagerVideoConsulta->getInfoVideoConsultaPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);


        if ($info_videoconsulta) {
            $periodo_pago["total_videoconsulta"] = $info_videoconsulta["cantidad_videoconsulta"];
            $periodo_pago["importe_videoconsulta"] = $info_videoconsulta["monto_tarifa"];
            $periodo_pago["importe_comision_videoconsulta"] = $info_videoconsulta["monto_comision_doctor_plus"];
        }
        $update = parent::update($periodo_pago, $periodo_pago[$this->id]);
        //$acreditar_videoconsulta_finalizadas = $ManagerVideoConsulta->acreditarVideoConsultaFinalizadaPeriodo($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);

        if ($update) {

            return true;
        }


        return false;
    }

    /**
     * Método que retorna el PDF con los resultados de la encuesta
     * @param type $request
     */
    public function getPDF($request) {

        //creamos el array con los datos necesarios para el reporte
        $periodo = $this->get($request["idperiodoPago"]);

        if (CONTROLLER == "medico") {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        } else {
            $idmedico = $periodo["medico_idmedico"];
        }



        if ($periodo["medico_idmedico"] != $idmedico) {
            return false;
        }
        //ültimo día del mes del período de pago
        $fecha_fin_periodo = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo["mes"] + 1, 0, $periodo["anio"]));
        $fecha_inicio_periodo = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo["mes"], 1, $periodo["anio"]));

        $periodo["mes_format"] = getNombreMes($periodo["mes"]);

        //iniciamos la numeracion el 100
        $numero_factura = 100 + $periodo["idperiodoPago"];
        $periodo["numero_factura"] = STR_PAD($numero_factura, 9, "0", STR_PAD_LEFT);





        $medico = $this->getManager("ManagerMedico")->get($idmedico, true);
        $data_variables["medico"] = $medico;
        $movimientos = $this->getManager("ManagerMovimientoCuenta")->getListadoMovimientosPeriodoMedico($fecha_inicio_periodo, $fecha_fin_periodo, $idmedico);
        $data_variables["listado_movimientos"] = $movimientos;
//buscamos los totales de consultas con reintegro para medicos frances
        if ($medico["pais_idpais"] == 1) {
            //consultas pendientes facturacion cpam
            $filtro["filtro_inicio"] = $fecha_inicio_periodo;
            $filtro["filtro_fin"] = $fecha_fin_periodo;
            //totales consultas reintegro
            $totales_consultas_reintegro = $this->getManager("ManagerVideoConsulta")->get_totales_consultas_reintegro_periodo($filtro);

            //videoconsultas reintegro
            $periodo["total_videoconsulta_reintegro"] = $totales_consultas_reintegro["total_videoconsulta_reintegro"] + $totales_consultas_reintegro["total_videoconsulta_ald"];
            $periodo["importe_videoconsulta_reintegro"] = $totales_consultas_reintegro["importe_videoconsultas_reintegro"] + $totales_consultas_reintegro["importe_videoconsultas_ald"];
            $periodo["importe_comision_videoconsulta_reintegro"] = $totales_consultas_reintegro["importe_comision_videoconsulta_reintegro"];

            //sumamos las videoconsultas ald  a las con reintegro
            //$periodo["total_videoconsulta_ald"] = $totales_consultas_reintegro["total_videoconsulta_ald"];
            //$periodo["importe_videoconsultas_ald"] = $totales_consultas_reintegro["importe_videoconsultas_ald"];
            //videoconsultas particulares
            $periodo["total_videoconsulta_particulares"] = $periodo["total_videoconsulta"] - $periodo["total_videoconsulta_ald"] - $periodo["total_videoconsulta_reintegro"];
            $periodo["importe_videoconsulta_particulares"] = $periodo["importe_videoconsulta"] - $periodo["importe_videoconsultas_ald"] - $periodo["importe_videoconsulta_reintegro"];
            $periodo["importe_comision_videoconsulta_particulares"] = $periodo["importe_comision_videoconsulta"] - $periodo["importe_comision_videoconsulta_reintegro"];



            //obtenemos el listado detallado de consultas que benefician reintegro
            //consultas pendientes facturacion cpam
            $filtro["filtro_inicio"] = $fecha_inicio_periodo;
            $filtro["filtro_fin"] = $fecha_fin_periodo;
            $filtro["pendientes"] = 1;
            $listado_cpam_pendientes = $this->getManager("ManagerVideoConsulta")->get_listado_consultas_reintegro_resumen_periodo($filtro);
            $data_variables["listado_cpam_pendientes"] = $listado_cpam_pendientes;

            //consultas facturadas cpam
            $filtro["filtro_inicio"] = $fecha_inicio_periodo;
            $filtro["filtro_fin"] = $fecha_fin_periodo;
            $filtro["pendientes"] = 0;
            $listado_cpam_facturadas = $this->getManager("ManagerVideoConsulta")->get_listado_consultas_reintegro_resumen_periodo($filtro);
            $data_variables["listado_cpam_facturadas"] = $listado_cpam_facturadas;
        } else {
            //todas las consultas son particulares
            //videoconsultas particulares
            $periodo["total_videoconsulta_particulares"] = $periodo["total_videoconsulta"];
            $periodo["importe_videoconsulta_particulares"] = $periodo["importe_videoconsulta"];
            $periodo["importe_comision_videoconsulta_particulares"] = $periodo["importe_comision_videoconsulta"];
        }


        $data_variables["periodo"] = $periodo;


        //datos factura medico
        if ($medico["fundador"] == 1) {
            $datos_factura[] = "Coût d'utilisation de la Solution WorknCare";
            $datos_factura[] = "Commission sur consultations";
            $total = $periodo["importe_comision_videoconsulta"] + $periodo["importe_comision_consulta_express"];

            $datos_factura[] = 0;
            $datos_factura[] = 0;
            $datos_factura[] = 0;
        } else if ($medico["planProfesional"] == 1) {
            $datos_factura[] = "Coût d'utilisation de la Solution WorknCare";
            $datos_factura[] = "Abonnement mensuel";
            $total = MONTO_CUOTA;
            $TVA = round($total * 0.2, 2);
            $datos_factura[] = $total - $TVA;
            $datos_factura[] = $TVA;

            $datos_factura[] = $total;
        } else {
            $datos_factura[] = "Coût d'utilisation de la Solution WorknCare";
            $datos_factura[] = "Commission sur consultations";
            $total = $periodo["importe_comision_videoconsulta"] + $periodo["importe_comision_consulta_express"];
            $TVA = round($total * 0.2, 2);
            $datos_factura[] = $total - $TVA;
            $datos_factura[] = $TVA;

            $datos_factura[] = $total;
        }
        $data_variables["datos_factura"] = [$datos_factura];

        $filtroFechas["filtro_inicio"] = $fecha_inicio_periodo;
        $filtroFechas["filtro_fin"] = $fecha_fin_periodo;
        $listado_consultas_beneficiarios = $this->getManager("ManagerMedico")->getConsultasBeneficiario($filtroFechas);
        $data_variables["listado_consultas_beneficiarios"] = $listado_consultas_beneficiarios;
        $infofiscal = $this->getManager("ManagerInformacionComercialMedico")->getInformacionComercialMedico($idmedico);
        $data_variables["infofiscal"] = $infofiscal;
        //$this->print_r($data_variables);
        // die();
        //$this->print_r($data_variables["listado_movimientos"]);
        //inatanciamos la clase que crea los pdf
        $PDFResumenPeriodo = new PDFResumenPeriodo();

        $PDFResumenPeriodo->getPDF($data_variables);
    }

}
