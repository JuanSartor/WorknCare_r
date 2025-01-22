<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de la consulta expres
 *  ATENCIÓN: La implementación realizada aquí es prototipo para mostrar el detalle de la factura
 * porque todavía no está implementado la consulta express
 *
 */
class ManagerConsultaExpress extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "consultaexpress", "idconsultaExpress");
        $this->setFlag("active");
    }

    /**
     * 	Inserta un registro en la tabla correspondiente basandose en el arreglo recibido como par�metro
     *
     * 	@author lucas
     * 	@version 1.0
     *
     * 	@param mixed $request Arreglo que contiene todos los campos a insertar
     * 	@return int Retorna el ID Insertado o 0
     */
    public function insert($request) {

        //creo el registro
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
            $request["prestador_idprestador"] = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"];
        }
        $id = parent::insert($request);
        //creamos el numero de consulta express formateado
        $record["numeroConsultaExpress"] = STR_PAD($id, 7, "0", STR_PAD_LEFT);

        $rdo = parent::update($record, $id);

        if ($id && $rdo) {
            $this->setMsg(["msg" => "Se ha creado la consulta express con éxito", "result" => true, "id" => $id]);

            // <-- LOG
            $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["page"] = "Conseil";
            $log["purpose"] = "Send Conseil request to connected Frequent Professional";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);

            // <--  
            return $id;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo crear la consulta express", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que obtiene las consultas express pertenecientes a un determinado 
     * período de pago
     * @param type $idperiodoPago
     * @return type
     */
    public function getListPacientesConsultaExpressPeriodoPago($idperiodoPago) {
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
        $periodo_pago = $ManagerPeriodoPago->get($idperiodoPago);

        $fecha_fin_periodo = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
        $fecha_inicio_periodo = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table ");
        $query->setWhere("fecha_fin BETWEEN '$fecha_inicio_periodo' AND '$fecha_fin_periodo'");
        $query->addAnd("medico_idmedico = $idmedico");
        $query->addAnd("estadoConsultaExpress_idestadoConsultaExpress = 4");
        $listado = $this->getList($query);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        foreach ($listado as $key => $value) {
            $listado[$key]["paciente"] = $ManagerPaciente->get($value["paciente_idpaciente"]);
        }

        return $listado;
    }

    /*     * Metodo que obtiene la ultima consulta express del paciente que quedo en estado borrador
     * 
     * @param type $idpaciente
     */

    public function getConsultaExpressBorrador($idpaciente) {

        return $this->db->getRow("select * from $this->table where paciente_idpaciente=$idpaciente and estadoConsultaExpress_idestadoConsultaExpress=6");
    }

    /*     * Metodo que obtiene la consulta express de un paciente validando que pertenzca a este
     * 
     * @param type $idconsultaexpress
     */

    public function get($idconsultaexpress) {
        $consulta = parent::get($idconsultaexpress);

        /**
         * Verifico que no se intente acceder a una consulta express alguien que no lo tenga permitido
         */
        if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ($consulta["medico_idmedico"] != $idmedico && $consulta["tipo_consulta"] != 0) {
                header('Location:' . URL_ROOT . "panel-medico/consultaexpress/");
                exit;
            }
        } elseif (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
                header('Location:' . URL_ROOT . "panel-paciente/consultaexpress/");
                exit;
            }
        } elseif (CONTROLLER == "common") {
            return parent::get($idconsultaexpress);
        }
        return $consulta;
    }

    /**
     * metodo que retorna un array con las cantidades de consultas en los diferentes estados no leidas por el medico en sesion* */
    public function getCantidadConsultasExpressMedicoXEstado($idespecialidad = null) {

        $this->actualizarEstados();


        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $result["ispermitido"] = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico)["valorPinesConsultaExpress"] > 0 ? 1 : 0;

        $result["pendientes"] = $this->db->GetOne("select count(*) as pendientes from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=1 and visualizar_consulta_medico=1 and medico_idmedico=$idmedico ");

        $result["abiertas"] = $this->db->GetOne("select count(*) as abiertas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=2  and visualizar_consulta_medico=1  and medico_idmedico=$idmedico ");

        $result["abiertas_total"] = $this->db->GetOne("select count(*) as abiertas_total from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=2  and visualizar_consulta_medico=1 and medico_idmedico=$idmedico ");

        $result["rechazadas"] = $this->db->GetOne("select count(*) as rechazadas from $this->table 
          where estadoConsultaExpress_idestadoConsultaExpress=3 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["rechazadas_total"] = $this->db->GetOne("select count(*) as rechazadas_total from $this->table 
          where estadoConsultaExpress_idestadoConsultaExpress=3 and medico_idmedico=$idmedico ");

        $result["finalizadas"] = $this->db->GetOne("select count(*) as finalizadas from $this->table 
          where estadoConsultaExpress_idestadoConsultaExpress=4 and medico_idmedico=$idmedico ");

        $result["pendientes_finalizacion"] = $this->db->GetOne("select count(*) as pendientes_finalizacion from $this->table 
          where estadoConsultaExpress_idestadoConsultaExpress=8 and medico_idmedico=$idmedico ");

        $result["finalizadas_total"] = $this->db->GetOne("select count(*) as finalizadas_total from $this->table 
          where (estadoConsultaExpress_idestadoConsultaExpress=4 OR estadoConsultaExpress_idestadoConsultaExpress=8)  and medico_idmedico=$idmedico ");

        $result["vencidas"] = $this->db->GetOne("select count(*) as vencidas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=5  and visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=$idmedico ");
        $result["vencidas_total"] = $this->db->GetOne("select count(*) as vencidas_total from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=5  and visualizar_consulta_medico=1 and medico_idmedico=$idmedico ");


        $result["red"] = $this->db->GetOne("select count(*) as red from $this->table ce where estadoConsultaExpress_idestadoConsultaExpress=1 AND tipo_consulta=0 AND ce.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");

//valor que se muestra en el icono superior de CE
        $result["notificacion_general"] = (int) $result["pendientes"] + (int) $result["abiertas"] + (int) $result["pendientes_finalizacion"] + (int) $result["red"];


        return $result;
    }

    /**
     * metodo que retorna un array con las cantidades de consultas en los diferentes estados no leidas por el paciente */
    public function getCantidadConsultasExpressPacienteXEstado($idpaciente = null) {


        $this->actualizarEstados();
        if (is_null($idpaciente)) {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }


        $result["ispermitido"] = $this->getManager("ManagerPaciente")->isPermitidoConsultaExpress($idpaciente);

        if ($result["ispermitido"] == "1") {
            $result["pendientes"] = $this->db->GetOne("select count(*) as pendientes from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=1 and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");


            $result["abiertas"] = $this->db->GetOne("select count(*) as abiertas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=2 and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");

            $result["abiertas_total"] = $this->db->GetOne("select count(*) as abiertas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=2 and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");

            $result["rechazadas"] = $this->db->GetOne("select count(*) as rechazadas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=3 and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["rechazadas_total"] = $this->db->GetOne("select count(*) as rechazadas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=3 and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");

            $result["finalizadas"] = $this->db->GetOne("select count(*) as finalizadas from $this->table 
                  where (estadoConsultaExpress_idestadoConsultaExpress=4 OR estadoConsultaExpress_idestadoConsultaExpress=8)  and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");
            $result["finalizadas_total"] = $this->db->GetOne("select count(*) as finalizadas from $this->table 
                  where (estadoConsultaExpress_idestadoConsultaExpress=4 OR estadoConsultaExpress_idestadoConsultaExpress=8)  and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");

            $result["vencidas"] = $this->db->GetOne("select count(*) as vencidas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=5  and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");
            $result["vencidas_total"] = $this->db->GetOne("select count(*) as vencidas from $this->table 
                  where estadoConsultaExpress_idestadoConsultaExpress=5  and visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");

            //valor que se muestra en el icono superior de CE
            $result["notificacion_general"] = (int) $result["pendientes"] + (int) $result["rechazadas"] + (int) $result["abiertas"] + (int) $result["finalizadas"] + (int) $result["vencidas"];
        }



        return $result;
    }

    /* metodo que setea las notificaciones de consulta express como leidas segun su estado, cuando el medico ingresa a la bandeja de entrada * */

    public function setNotificacionesLeidasMedico($request) {

        //seteamos como leida una consulta en particular si viene el id
        if (isset($request["idconsultaExpress"]) && $request["idconsultaExpress"] != "") {
            $this->db->Execute("update $this->table set leido_medico=1 where idconsultaExpress=" . $request["idconsultaExpress"]);
            //evento de cambio de estado
            $consulta = parent::get($request["idconsultaExpress"]);
            $client = new XSocketClient();
            $client->emit('cambio_estado_consultaexpress_php', $consulta);
        } else {
            //seteamos como leidas todas las pertenecientes a una bandeja
            $idestado = $request["idestadoConsultaExpress"];
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $this->db->Execute("update $this->table set leido_medico=1 where estadoConsultaExpress_idestadoConsultaExpress=$idestado  
                and medico_idmedico=$idmedico ");
        }
    }

    /* metodo que setea las notificaciones de consulta express como leidas segun su estado, cuando el paciente ingresa a la bandeja de entrada * */

    public function setNotificacionesLeidasPaciente($request) {


        //seteamos como leida una consulta en particular si viene el id
        if (isset($request["idconsultaExpress"]) && $request["idconsultaExpress"] != "") {
            $this->db->Execute("update $this->table set leido_paciente=1 where idconsultaExpress=" . $request["idconsultaExpress"]);
            //evento de cambio de estado
            /* $consulta = parent::get($request["idconsultaExpress"]);
              $client = new XSocketClient();
              $client->emit('cambio_estado_consultaexpress_php', $consulta); */
        } else {
            //seteamos como leidas todas las pertenecientes a una bandeja
            $idestado = $request["idestadoConsultaExpress"];
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            $this->db->Execute("update $this->table set leido_paciente=1 where estadoConsultaExpress_idestadoConsultaExpress=$idestado  
                and paciente_idpaciente=$idpaciente");
        }
    }

    /**
     * Listado paginado de consultas express
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoConsultasExpressMedico($request, $idpaginate = null) {

        //las consultas pendientes de finalizacion van sin paginar
        if ($request["idestadoConsultaExpress"] != 8) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 10);
            }

            //Seteo el current page
            $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
            SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        }
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];


        $query = new AbstractSql();

        $query->setSelect("t.*,
                            mr.motivoRechazo,
                            mc.motivoConsultaExpress,
                            ps.idperfilSaludConsulta
                            
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            LEFT JOIN perfilsaludconsulta ps ON (ps.consultaExpress_idconsultaExpress=t.idconsultaExpress AND ps.is_cerrado = 1)
                            LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress=t.motivoConsultaExpress_idmotivoConsultaExpress) 
                            LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo=t.motivoRechazo_idmotivoRechazo)
                            
                        ");



        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado 
        $query->addAnd("t.estadoConsultaExpress_idestadoConsultaExpress=" . $request["idestadoConsultaExpress"]);


        $query->addAnd("t.visualizar_consulta_medico = 1");

        //añadimos los filtros de fecha
        if ($request["idestadoConsultaExpress"] == 4) {
            if ($request["filtro_inicio"] != "") {
                $filtro_inicio = $this->sqlDate($request["filtro_inicio"]);
                $query->addAnd("t.fecha_fin >= '{$filtro_inicio}'");
            }
            if ($request["filtro_fin"] != "") {
                $filtro_fin = $this->sqlDate($request["filtro_fin"]);
                $query->addAnd("t.fecha_fin <= '{$filtro_fin}'");
            }
        }


        //si estam abiertas o finalizadas las ordenamos por la ultima interaccion mediante los mensajes enviados
        if ($request["idestadoConsultaExpress"] == 2 || $request["idestadoConsultaExpress"] == 4 || $request["idestadoConsultaExpress"] == 8) {
            $query->setOrderBy("t.fecha_ultimo_mensaje DESC");
        } else if ($request["idestadoConsultaExpress"] == 1) {//si estan pendientes las ordenamos por la mas proxima a vencer
            $query->setOrderBy("t.fecha_vencimiento ASC");
        } else {
            $query->setOrderBy("t.fecha_inicio DESC");
        }

        $query->setGroupBy("t.idconsultaExpress");
        //las consultas pendientes de finalizacion van sin paginar
        if ($request["idestadoConsultaExpress"] == 8) {
            $listado_rows = $this->getList($query);
            $listado["rows"] = $listado_rows;
        } else {
            $listado = $this->getListPaginado($query, $idpaginate);
        }


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $imagen_medico = $ManagerMedico->getImagenMedico($idmedico);

            foreach ($listado["rows"] as $key => $value) {
                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_inicio"] != "") {
                    $listado["rows"][$key]["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
                }

                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_fin"] != "") {
                    $listado["rows"][$key]["fecha_fin_format"] = fechaToString($value["fecha_fin"], 1);
                }

                //Diferencia de consulta express en segundos para el vencimienot
                if ($value["tipo_consulta"] == 1 && $value["fecha_vencimiento"] != "") {

                    $segundos = strtotime($value["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = false;
                    }
                }
                //Diferencia de consulta express en segundos de consultas tomadas
                if ($value["tipo_consulta"] == 0 && $value["fecha_vencimiento_toma"] != "") {

                    $segundos = strtotime($value["fecha_vencimiento_toma"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = false;
                    }
                }


                //Traigo la informacion del paciente
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($value["paciente_idpaciente"]);

                //obtenemos el titular de la cuenta si es un familiar
                $realciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $value["paciente_idpaciente"]);
                if ($realciongrupo["pacienteTitular"] != "") {
                    //Traigo la informacion del paciente titular
                    $listado["rows"][$key]["paciente_titular"] = $ManagerPaciente->get($realciongrupo["pacienteTitular"]);
                    $listado["rows"][$key]["paciente_titular"]["relacion"] = $this->getManager("ManagerRelacionGrupo")->get($realciongrupo["relacionGrupo_idrelacionGrupo"])["relacionGrupo"];
                }

                //traigo los mensajes de la consulta
                $listado["rows"][$key]["mensajes"] = $ManagerMensajeConsultaExpress->getListadoMensajes($value["idconsultaExpress"]);

                //traigo la cantidad de mensajes sin leer
                $listado["rows"][$key]["mensajes_noleidos"] = $ManagerMensajeConsultaExpress->getCantidadMensajesNoLeidos($value["idconsultaExpress"], "m")["qty"];
                $listado["rows"][$key]["medico"]["image"] = $imagen_medico;
            }

            return $listado;
        }
    }

    /**
     * Metodo que devuelve el contador de consultas en la red en la que estuvo asignado el medico
     * @return type
     */
    public function getHistoricoConsultasExpressRed() {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $consulta_red_historica = $this->db->GetOne("select count(*) as red from consultaexpress ce where estadoConsultaExpress_idestadoConsultaExpress<>1  AND tipo_consulta=0 AND ce.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");
        return $consulta_red_historica;
    }

    /**
     * Listado paginado de consultas express en la bolsa de medicos
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoConsultasExpressRed($request, $idpaginate = null) {


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
        // $especialidades = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesString($idmedico);
        //puede venir una respecialidad en el request o varias concatenadas por ',' en el filtro de busqueda
        //si no vienen seteadas las especialidades en el request las obtenemos del medico

        /* if ($request["from_filtro"] == "1" && isset($request["idespecialidad"])) {
          $especialidades = implode(",", $request["idespecialidad"]);
          } else {
          $especialidades = implode(",", $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesList($idmedico, true));
          } */
        /**
         * Status 1=medico incluido en la bola
         *  Status 2 =medico no incluido porque no cumple con el rango de precios
         *  Status 2 =medico no incluido porque no cumple con los parametros de busqueda
         * * */
        $query = new AbstractSql();

        $query->setSelect("
		ce.*, 
                f.rango_minimo,
                mc.motivoConsultaExpress,
                f.rango_maximo,
                CASE 
                    WHEN ce.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%')) THEN 1 
                     ELSE GetExcluidoRangoPrecioCE($idmedico,f.rango_minimo,f.rango_maximo) 
                END as status
		      ");
        $query->setFrom("consultaexpress ce
		INNER JOIN filtrosbusquedaconsultaexpress f ON (f.consultaExpress_idconsultaExpress = ce.idconsultaExpress)
                LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress = ce.motivoConsultaExpress_idmotivoConsultaExpress)"
        );
        $query->setWhere("ce.tipo_consulta = 0");
        $query->addAnd("ce.estadoConsultaExpress_idestadoConsultaExpress = 1");

        $query->addAnd("ce.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");


        if (isset($request["idsubespecialidad"])) {
            $subespecialidades = implode(",", $request["idespecialidad"]);

            $query->addAnd("f.subEspecialidad_idsubEspecialidad in ($subespecialidades)");
        }
        if (isset($request["rango_minimo"]) && $request["rango_minimo"] != "") {
            $query->addAnd("f.rango_minimo >= " . $request["rango_minimo"]);
        }
        if (isset($request["rango_maximo"]) && $request["rango_maximo"] != "") {
            $query->addAnd("f.rango_maximo <= " . $request["rango_maximo"]);
        }

        $query->setOrderBy("ce.fecha_ultimo_mensaje DESC");


        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
            $ManagerMedico = $this->getManager("ManagerMedico");

            foreach ($listado["rows"] as $key => $value) {
                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_inicio"] != "") {
                    $listado["rows"][$key]["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
                }
                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_fin"] != "") {
                    $listado["rows"][$key]["fecha_fin_format"] = fechaToString($value["fecha_fin"], 1);
                }

                //Diferencia de consulta express en segundos
                if ($value["fecha_vencimiento"] != "") {
                    $segundos = strtotime($value["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = 0;
                    }
                }

                //Si esta tomada traigo la info del medico que la tomo
                if ($value["tomada"] == "1") {

                    $listado["rows"][$key]["medico_tomada"] = $ManagerMedico->get($value["medico_idmedico"], true);
                    $listado["rows"][$key]["medico_tomada"]["imagen"] = $ManagerMedico->getImagenMedico($value["medico_idmedico"]);

                    //Diferencia de tiempo restante consulta tomada en segundos
                    if ($value["fecha_vencimiento_toma"] != "") {

                        $segundos = strtotime($value["fecha_vencimiento_toma"]) - strtotime(date("Y-m-d H:i:s"));
                        if ($segundos > 0) {
                            $listado["rows"][$key]["segundos_diferencia_toma"] = $segundos;
                        } else {
                            $listado["rows"][$key]["segundos_diferencia_toma"] = 0;
                        }
                    }
                }


                //Traigo la informacion del paciente
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($value["paciente_idpaciente"]);

                //obtenemos el titular de la cuenta si es un familiar
                $realciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $value["paciente_idpaciente"]);
                if ($realciongrupo["pacienteTitular"] != "") {
                    //Traigo la informacion del paciente titular
                    $listado["rows"][$key]["paciente_titular"] = $ManagerPaciente->get($realciongrupo["pacienteTitular"]);
                    $listado["rows"][$key]["paciente_titular"]["relacion"] = $this->getManager("ManagerRelacionGrupo")->get($realciongrupo["relacionGrupo_idrelacionGrupo"])["relacionGrupo"];
                }

                //traigo los mensajes de la consulta
                $listado["rows"][$key]["mensajes"] = $ManagerMensajeConsultaExpress->getListadoMensajes($value["idconsultaExpress"]);

                //traigo la cantidad de mensajes sin leer
                $listado["rows"][$key]["mensajes_noleidos"] = $ManagerMensajeConsultaExpress->getCantidadMensajesNoLeidos($value["idconsultaExpress"], "m")["qty"];
            }

            //   print_r($listado);
            return $listado;
        }
    }

    /**
     * Listado paginado de consultas express
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoConsultasExpressPaciente($request, $idpaginate = null) {
        //las consultas pendientes de finalizacion van sin paginar


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }
        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            mr.motivoRechazo,
                            mc.motivoConsultaExpress,
                            ps.idperfilSaludConsulta
                        ");
        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress=t.motivoConsultaExpress_idmotivoConsultaExpress) 
                            LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo=t.motivoRechazo_idmotivoRechazo)
                            LEFT JOIN perfilsaludconsulta ps ON (ps.consultaExpress_idconsultaExpress=t.idconsultaExpress)
                        ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("visualizar_consulta_paciente = 1");

        if ($request["idestadoConsultaExpress"] == 4) {
            //filtramos por el estado finalizadas o pendientes de finalizacion
            $query->addAnd("t.estadoConsultaExpress_idestadoConsultaExpress=4 OR t.estadoConsultaExpress_idestadoConsultaExpress=8");
            //añadimos los filtros de fecha
            if ($request["filtro_inicio"] != "") {
                $filtro_inicio = $this->sqlDate($request["filtro_inicio"]);
                $query->addAnd("t.fecha_fin >= '{$filtro_inicio}'");
            }
            if ($request["filtro_fin"] != "") {
                $filtro_fin = $this->sqlDate($request["filtro_fin"]);
                $query->addAnd("t.fecha_fin <= '{$filtro_fin}'");
            }
        } else {
            //filtramos por el estado

            $query->addAnd("t.estadoConsultaExpress_idestadoConsultaExpress=" . $request["idestadoConsultaExpress"]);
        }

//si estan abiertas o finalizadas las ordenamos por la ultima interaccion mediante los mensajes enviados
        if ($request["idestadoConsultaExpress"] == 2 || $request["idestadoConsultaExpress"] == 4 || $request["idestadoConsultaExpress"] == 8) {
            $query->setOrderBy("t.fecha_ultimo_mensaje DESC");
        } else if ($request["idestadoConsultaExpress"] == 1) {
            //si estan pendientes las ordenamos por la mas proxima a vencer
            $query->setOrderBy("t.fecha_vencimiento ASC");
        } else {
            $query->setOrderBy("t.fecha_inicio DESC");
        }

        $query->setGroupBy("t.idconsultaExpress");

        $listado = $this->getListPaginado($query, $idpaginate);


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
            $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
            $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
            $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
            $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");

            foreach ($listado["rows"] as $key => $value) {

                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_inicio"] != "") {
                    $listado["rows"][$key]["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
                }

                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_fin"] != "") {
                    $listado["rows"][$key]["fecha_fin_format"] = fechaToString($value["fecha_fin"], 1);
                }

                //Tengo que formatear la fecha del último mensaje.
                if ($value["fecha_ultimo_mensaje"] != "") {
                    $listado["rows"][$key]["fecha_ultimo_mensaje_format"] = fechaToString($value["fecha_ultimo_mensaje"], 1);
                }


                //Traigo la informacion del paciente
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($value["paciente_idpaciente"]);

                $listado["rows"][$key]["medico"] = $ManagerMedico->get($value["medico_idmedico"], true);
                $listado["rows"][$key]["medico"]["imagen"] = $ManagerMedico->getImagenMedico($value["medico_idmedico"]);
                if ($value["tipo_consulta"] == "0") {
                    $filtro = $ManagerFiltrosBusquedaConsultaExpress->getByField("consultaExpress_idconsultaExpress", $value["idconsultaExpress"]);
                    if ($filtro["especialidad_idespecialidad"] != "") {
                        $listado["rows"][$key]["especialidad"] = $ManagerEspecialidades->get($filtro["especialidad_idespecialidad"])["especialidad"];
                    }
                    if ($filtro["idprograma_categoria"] != "") {

                        $programa_categoria = $ManagerProgramaSaludCategoria->get($filtro["idprograma_categoria"]);
                        $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                        $listado["rows"][$key]["programa_categoria"] = $programa_categoria;
                        $listado["rows"][$key]["programa_salud"] = $programa_salud;
                    } else if ($filtro["idprograma_salud"] != "") {

                        $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                        $listado["rows"][$key]["programa_salud"] = $programa_salud;
                    }
                }
                //Diferencia de consulta express en segundos para el vencimienot
                if ($value["estadoConsultaExpress_idestadoConsultaExpress"] == 1 && $value["fecha_vencimiento"] != "") {

                    $segundos = strtotime($value["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = false;
                    }
                }


                //obtenemos el titular de la cuenta si es un familiar
                $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $value["paciente_idpaciente"]);
                if ($relaciongrupo["pacienteTitular"] != "") {
                    //Traigo la informacion del paciente titular
                    $listado["rows"][$key]["paciente_titular"] = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
                    $relacion_grupo = $this->getManager("ManagerRelacionGrupo")->get($relaciongrupo["relacionGrupo_idrelacionGrupo"]);
                    $listado["rows"][$key]["paciente_titular"]["relacion"] = $relacion_grupo["relacionGrupo"];
                }
                //recuperamos el programa al que pertenece
                if ((int) $value["idprograma_categoria"] > 0) {
                    $programa_categoria = $ManagerProgramaSaludCategoria->get($value["idprograma_categoria"]);
                    $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                    $listado["rows"][$key]["programa_categoria"] = $programa_categoria;
                    $listado["rows"][$key]["programa_salud"] = $programa_salud;
                }

                //traigo los mensajes de la consulta
                $listado["rows"][$key]["mensajes"] = $ManagerMensajeConsultaExpress->getListadoMensajes($value["idconsultaExpress"]);

                //traigo la cantidad de mensajes sin leer
                $listado["rows"][$key]["mensajes_noleidos"] = $ManagerMensajeConsultaExpress->getCantidadMensajesNoLeidos($value["idconsultaExpress"], "p")["qty"];
            }
            return $listado;
        }
    }

    /**
     * Método que retorna una consulta express desde el lado del paciente
     * @param type $request
     * @return boolean
     */
    public function getConsultaExpressPaciente($request) {

        if ($request["paciente_idpaciente"] == "") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        } else {
            $idpaciente = $request["paciente_idpaciente"];
        }

        $CE = $this->get($request[$this->id]);
        //verificamos que la consulta pertenzeca al paciente
        if ($CE["paciente_idpaciente"] != $idpaciente || $CE["estadoConsultaExpress_idestadoConsultaExpress"] != $request["idestadoConsultaExpress"]) {
            //throw new ExceptionErrorPage("No se pudo recuperar la consulta");
            //redirigir  a la home
            header('Location:' . URL_ROOT . "panel-paciente/consultaexpress/");
            exit;
        }

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            mr.motivoRechazo,
                            mc.motivoConsultaExpress,
                            ps.idperfilSaludConsulta
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            LEFT JOIN motivoconsultaexpress mc ON (mc.idmotivoConsultaExpress=t.motivoConsultaExpress_idmotivoConsultaExpress) 
                            LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo=t.motivoRechazo_idmotivoRechazo)
                                                        LEFT JOIN perfilsaludconsulta ps ON (ps.consultaExpress_idconsultaExpress=t.idconsultaExpress)

                        ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");
        //estado abierta
        $query->addAnd("t.estadoConsultaExpress_idestadoConsultaExpress={$request["idestadoConsultaExpress"]}");

        $query->addAnd("t.{$this->id}={$request[$this->id]}");

        $query->addAnd("visualizar_consulta_paciente = 1");

        //si estam abiertas o finalizadas las ordenamos por la ultima interaccion mediante los mensajes enviados
        if ($request["idestadoConsultaExpress"] == 2 || $request["idestadoConsultaExpress"] == 4) {
            $query->setOrderBy("t.fecha_ultimo_mensaje DESC");
        } else {
            $query->setOrderBy("t.fecha_inicio DESC");
        }

        $consulta = $this->db->GetRow($query->getSql());

        if ($consulta) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
            $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
            $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
            $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
            $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
            //Tengo que formatear la fecha de inicio.
            if ($consulta["fecha_inicio"] != "") {
                $consulta["fecha_inicio_format"] = fechaToString($consulta["fecha_inicio"], 1);
            }

            //Tengo que formatear la fecha de inicio.
            if ($consulta["fecha_fin"] != "") {
                $consulta["fecha_fin_format"] = fechaToString($consulta["fecha_fin"], 1);
            }

            //Tengo que formatear la fecha del último mensaje.
            if ($consulta["fecha_ultimo_mensaje"] != "") {
                $consulta["fecha_ultimo_mensaje_format"] = fechaToString($consulta["fecha_ultimo_mensaje"], 1);
            }

            //Diferencia de consulta express en segundos para el vencimienot
            if ($consulta["tipo_consulta"] == 1 && $consulta["fecha_vencimiento"] != "") {

                $segundos = strtotime($consulta["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                if ($segundos > 0) {
                    $consulta["segundos_diferencia"] = $segundos;
                } else {
                    $consulta["segundos_diferencia"] = false;
                }
            }
            //Diferencia de consulta express en segundos de consultas tomadas
            if ($consulta["tipo_consulta"] == 0) {
                if ($consulta["fecha_vencimiento"] != "") {

                    $segundos = strtotime($consulta["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $consulta["segundos_diferencia"] = $segundos;
                    } else {
                        $consulta["segundos_diferencia"] = false;
                    }
                }
                if ($consulta["fecha_vencimiento_toma"] != "") {


                    $segundos = strtotime($consulta["fecha_vencimiento_toma"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $consulta["segundos_diferencia"] = $segundos;
                    } else {
                        $consulta["segundos_diferencia"] = false;
                    }
                }
            }
            //Traigo la informacion del paciente
            $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

            $consulta["medico"] = $ManagerMedico->get($consulta["medico_idmedico"], true);
            $consulta["medico"]["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
            if ($consulta["tipo_consulta"] == "0") {
                $filtro = $ManagerFiltrosBusquedaConsultaExpress->getByField("consultaExpress_idconsultaExpress", $consulta["idconsultaExpress"]);

                if ($filtro["especialidad_idespecialidad"] != "") {
                    $consulta["especialidad"] = $ManagerEspecialidades->get($filtro["especialidad_idespecialidad"])["especialidad"];
                }
                if ($filtro["idprograma_categoria"] != "") {

                    $programa_categoria = $ManagerProgramaSaludCategoria->get($filtro["idprograma_categoria"]);
                    $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                    $consulta["programa_categoria"] = $programa_categoria;
                    $consulta["programa_salud"] = $programa_salud;
                } else if ($filtro["idprograma_salud"] != "") {

                    $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                    $consulta["programa_salud"] = $programa_salud;
                }
            }

            if ((int) $consulta["idprograma_categoria"] > 0) {
                $programa_categoria = $ManagerProgramaSaludCategoria->get($consulta["idprograma_categoria"]);
                $programa_salud = $ManagerProgramaSalud->get($programa_categoria["programa_salud_idprograma_salud"]);
                $consulta["programa_categoria"] = $programa_categoria;
                $consulta["programa_salud"] = $programa_salud;
            }


            //obtenemos el titular de la cuenta si es un familiar
            $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $consulta["paciente_idpaciente"]);
            if ($relaciongrupo["pacienteTitular"] != "") {
                //Traigo la informacion del paciente titular
                $consulta["paciente_titular"] = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
                $relacion_grupo = $this->getManager("ManagerRelacionGrupo")->get($relaciongrupo["relacionGrupo_idrelacionGrupo"]);
                $consulta["paciente_titular"]["relacion"] = $relacion_grupo["relacionGrupo"];
            }

            //traigo los mensajes de la consulta
            $consulta["mensajes"] = $ManagerMensajeConsultaExpress->getListadoMensajes($consulta["idconsultaExpress"]);

            //traigo la cantidad de mensajes sin leer
            $consulta["mensajes_noleidos"] = $ManagerMensajeConsultaExpress->getCantidadMensajesNoLeidos($consulta["idconsultaExpress"], "p")["qty"];

            return $consulta;
        }
        return false;
    }

    /*     * Metodo que cambia el estado de una consulta express
     * 
     * @param type $request
     * @return boolean
     */

    public function cambiarEstado($request) {

        //verificamos que vengan los campos necesarios
        if ($request["estadoConsultaExpress_idestadoConsultaExpress"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No se ha seleccionado un estado"]);
            return false;
        }

        if ($request["estadoConsultaExpress_idestadoConsultaExpress"] == "3" && $request["motivoRechazo_idmotivoRechazo"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione un motivo de rechazo"]);
            return false;
        }
        //seteamos quien es el emisor y el flag leido en 0 de la consulta express para que le aparezca la notificacion al receptor
        if (CONTROLLER == "medico") {
            $leido = "leido_paciente";
        }
        if (CONTROLLER == "paciente_p") {
            $leido = "leido_medico";
        }

        //si se finaliza o rechaza seteamos el horario de finalizacion
        if ($request["estadoConsultaExpress_idestadoConsultaExpress"] == "3" || $request["estadoConsultaExpress_idestadoConsultaExpress"] == "4" || $request["estadoConsultaExpress_idestadoConsultaExpress"] == "8") {
            $request["fecha_fin"] = date("Y-m-d H:i:s");
            $request[$leido] = 0;
        }

        $rdo = parent::update($request, $request["idconsultaExpress"]);
        if ($rdo) {
            $this->db->CompleteTrans();
            $client = new XSocketClient();
            $consulta_express = parent::get($request["idconsultaExpress"]);
            $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
            $this->setMsg(["result" => true, "msg" => "Se ha cambiado el estado de la consulta"]);

            if ($request["estadoConsultaExpress_idestadoConsultaExpress"] == "4") {
                // <-- LOG
                $log["data"] = "Confirmation";
                $log["page"] = "Conseil";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Finalize Conseil ONGOING";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se ha podido cambiar el estado de la consulta"]);
            return false;
        }
    }

    /*
     * Metodo que cambia automaticamente el estados de las consultas a vencidas luego de un tiempo desde la crecacion
     * 
     * @param type $request
     */

    public function actualizarEstados() {

        //actualizamos las consultas vencidas cuando el paciente ingresa a la bandeja de entrada
        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            if ($paciente["idpaciente"] == "") {
                $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
            } else {
                $idpaciente = $paciente["idpaciente"];
            }

//obtenemos las consultas realizadas por el paciente y que ha pasado el tiempo de publicacion
            $query = new AbstractSql();
            $query->setSelect("idconsultaExpress");
            $query->setFrom("$this->table");
            $query->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1 and tomada=0 and
                paciente_idpaciente=$idpaciente and SYSDATE()> fecha_vencimiento");
            $listado = $this->getList($query);



            if (count($listado) > 0) {



                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $CE) {

                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $consulta_express = $this->get($CE["idconsultaExpress"]);
                    if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    $res = $ManagerMovimientoCuenta->processVencimientoCE(["idconsultaExpress" => $CE["idconsultaExpress"]]);
                    //actualizamos el estado de la consulta
                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoConsultaExpress_idestadoConsultaExpress"] = 5;
                    $rdo = parent::update($record, $CE["idconsultaExpress"]);
                    //devolvemos el dinero a los pacientes

                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
                        //notify
                        $paciente = $ManagerPaciente->get($consulta_express["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Conseil expirée";
                        $notify["paciente_idpaciente"] = $consulta_express["paciente_idpaciente"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoCE($CE["idconsultaExpress"]);
                        $this->enviarSMSVencimientoCE($CE["idconsultaExpress"]);
                    }
                }
            }

            //actualizamos las consultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("$this->table");
            $queryTomadas->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1 and tipo_consulta=0 and tomada=1 and 
                paciente_idpaciente={$idpaciente}  and SYSDATE()> fecha_vencimiento_toma");

            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {
                //limpiamos los datos del medico que tomo la CE
                foreach ($tomadas as $CE) {
                    $this->db->StartTrans();
                    //actualizamos el tiempo que le queda
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["precio_tarifa"] = "";

                    $rdo1 = parent::update($record, $CE["idconsultaExpress"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }

                    $this->db->CompleteTrans();
                }
            }

            return;
        }
        //actualizamos las consultas vencidas cuando el medico ingresa a la bandeja de entrada
        if (CONTROLLER == "medico") {

            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            //obtenemos las conultas realiadas al medico  y que ha pasado el tiempo de publicacion
            $query = new AbstractSql();
            $query->setSelect("idconsultaExpress");
            $query->setFrom("$this->table");
            $query->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1  and tomada=0  and medico_idmedico=$idmedico            
                    and SYSDATE()>fecha_vencimiento ");
            $listado = $this->getList($query);



            if (count($listado) > 0) {

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $CE) {
                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $consulta_express = $this->get($CE["idconsultaExpress"]);
                    if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    //devolvemos el dinero a los pacientes y enviamos un mail
                    $res = $ManagerMovimientoCuenta->processVencimientoCE(["idconsultaExpress" => $CE["idconsultaExpress"]]);

                    //actualizamos el estado de la consulta
                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoConsultaExpress_idestadoConsultaExpress"] = 5;
                    $rdo = parent::update($record, $CE["idconsultaExpress"]);


                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
                        //notify
                        $paciente = $ManagerPaciente->get($consulta_express["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Conseil expirée";
                        $notify["paciente_idpaciente"] = $consulta_express["paciente_idpaciente"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoCE($CE["idconsultaExpress"]);
                        $this->enviarSMSVencimientoCE($CE["idconsultaExpress"]);
                    }
                }
            }


            //actualizamos las consultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("$this->table");
            $queryTomadas->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1 and tipo_consulta=0 and tomada=1 and
               medico_idmedico={$idmedico} and SYSDATE()> fecha_vencimiento_toma");
            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {

                foreach ($tomadas as $CE) {
                    $this->db->StartTrans();
                    //limpiamos los datos del medico que tomo la CE
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["precio_tarifa"] = "";

                    $rdo1 = parent::update($record, $CE["idconsultaExpress"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }
                    $this->db->CompleteTrans();
                }
            }

            return;
        }

        //actualizamos las consultas vencidas cuando el paciente ingresa a la bandeja de entrada
        if (CONTROLLER == "common") {

            //obtenemos las consultas realizadas  y que ha pasado el tiempo de publicacion
            $query = new AbstractSql();
            $query->setSelect("idconsultaExpress");
            $query->setFrom("$this->table");
            $query->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1 and tomada=0 
                and SYSDATE()> fecha_vencimiento");
            $listado = $this->getList($query);



            if (count($listado) > 0) {



                //devolvemos el dinero a los pacientes

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $CE) {
                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $consulta_express = $this->get($CE["idconsultaExpress"]);
                    if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    //devolvemos el dinero a los pacientes y enviamos un mail
                    $res = $ManagerMovimientoCuenta->processVencimientoCE(["idconsultaExpress" => $CE["idconsultaExpress"]]);

                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoConsultaExpress_idestadoConsultaExpress"] = 5;
                    $rdo = parent::update($record, $CE["idconsultaExpress"]);
                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
                        //notify
                        $paciente = $ManagerPaciente->get($consulta_express["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Conseil expirée";
                        $notify["paciente_idpaciente"] = $consulta_express["paciente_idpaciente"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoCE($CE["idconsultaExpress"]);
                        $this->enviarSMSVencimientoCE($CE["idconsultaExpress"]);
                    }
                }
            }

            //actualizamos las consultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("$this->table");
            $queryTomadas->setWhere("estadoConsultaExpress_idestadoConsultaExpress=1 and tipo_consulta=0 and tomada=1 and 
                 SYSDATE()> fecha_vencimiento_toma");

            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {
                //limpiamos los datos del medico que tomo la CE
                foreach ($tomadas as $CE) {
                    $this->db->StartTrans();
                    //actualizamos el tiempo que le queda
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["precio_tarifa"] = "";

                    $rdo1 = parent::update($record, $CE["idconsultaExpress"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }
                    $this->db->CompleteTrans();
                }
            }
            // actualiza las Consultas express que se han iniciado y termino el tiempo de consulta express sin ser finalizadas       
            $this->db->Execute("update $this->table set estadoConsultaExpress_idestadoConsultaExpress=8 
                             where estadoConsultaExpress_idestadoConsultaExpress=2 and SYSDATE()> DATE_ADD(fecha_inicio,INTERVAL 2 DAY)");


            return;
        }
    }

    /**
     * Pertenece al conjunto de metodos que crean la consulta express por parte de un paciente paso por paso
     * 
     * se establece en este paso si esta dirigida a profesionales en la red o a un medioc frecuente.
     * @param type $request
     */
    public function processConsultaExpressStep1($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;
        $request["estadoConsultaExpress_idestadoConsultaExpress"] = 6;

        $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
        if ($request["tipo_consulta"] == "0" || $request["tipo_consulta"] == "1") {
            $this->db->StartTrans();
            $request["consulta_step"] = 2;
            //verificamos si se esta actualizando una consulta o creando
            if (isset($request["idconsultaExpress"]) && $request["idconsultaExpress"] != "") {

                //validamos la consulta que pertenezca al paciente y este en borrador
                $ce = $this->get($request["idconsultaExpress"]);

                if ($ce["paciente_idpaciente"] != $idpaciente) {
                    $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                    return false;
                }
                $request["numeroConsultaExpress"] = STR_PAD($request["idconsultaExpress"], 7, "0", STR_PAD_LEFT);
                //asignamos los medicos de la especialidad si es consulta en la red
                $consulta = parent::update($request, $request["idconsultaExpress"]);
            } else {
                //creamos una consulta nueva
                $id = parent::insert($request);
                //creamos el numero de consulta express formateado
                $record["numeroConsultaExpress"] = STR_PAD($id, 7, "0", STR_PAD_LEFT);
                $request["idconsultaExpress"] = $id;
                $consulta = parent::update($record, $id);
            }
            //verificamos se regista la consulta correctamente
            if (!$consulta) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta"]);
                return false;
            }
            //creamos el registro de filtro de busqueda
            $filtros = $ManagerFiltrosBusquedaConsultaExpress->insert($request);
            if (!$filtros) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta"]);
                return false;
            }
            //asignamos los medicos de la especialidad si es consulta en la red
            if ($request["tipo_consulta"] == 0) {
                $medico_red = $this->processConsultaExpressStep2ProfesionalRed($request);
                if (!$medico_red) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha creado la consulta express con éxito", "result" => true, "id" => $request["idconsultaExpress"]]);
            return $consulta;
        } else {
            $this->setMsg(["result" => false, "msg" => "Seleccione a quien está dirigida la consulta"]);
            return false;
        }
    }

    /* Metodo que setea los medicos en la bolsa para la consulta express
     * 
     */

    public function processConsultaExpressStep2ProfesionalRed($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;
        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idconsultaExpress"]);

        if ($request["idconsultaExpress"] == "" || $consulta["paciente_idpaciente"] != $idpaciente || $consulta["estadoConsultaExpress_idestadoConsultaExpress"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
            return false;
        }


        $ids = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getIdsMedicosBolsa($request["idconsultaExpress"]);

        if ($ids == "") {
            $this->setMsg(["msg" => "Error. No hay profesionales para asignar la consulta", "result" => false, "no_profesionales" => 1]);

            return false;
        } else {
            $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $request["idconsultaExpress"]);

            $request["ids_medicos_bolsa"] = $ids;
            $request["consulta_step"] = 3;
            $request["idprograma_categoria"] = $filtro["idprograma_categoria"];

            $rdo = parent::update($request, $request["idconsultaExpress"]);
        }
        if ($rdo) {
            $this->setMsg(["msg" => "Profesionales asignados con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se han guardar los profesionales", "result" => false]);

            return false;
        }
    }

    /* Metodo que setea el medico al que esta asignada la consulta express
     * 
     */

    public function processConsultaExpressStep2ProfesionalFrecuente($request) {

        if ($request["idconsultaExpress"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);

            return false;
        }
        $consulta = $this->get($request["idconsultaExpress"]);

        //verificamos que el medico sea un profesional frecuente o favorito
        $frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($request["medico_idmedico"], $consulta["paciente_idpaciente"]);
        $favorito = $this->getManager("ManagerProfesionalFavorito")->isFavorito($request["medico_idmedico"], $consulta["paciente_idpaciente"]);
        if (!$frecuente && !$favorito) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el medico", "result" => false]);

            return false;
        }

        if ($request["medico_idmedico"] != "") {
            //La consulta express se hace a médico frecuente/favorito
            //Debo controlar que el médico no haya cambiado la preferencia, lo controlo con el rango_maximo
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
            $preferencia = $ManagerPreferencia->getPreferenciaMedico($request["medico_idmedico"]);
            if ($preferencia && (int) $preferencia["valorPinesConsultaExpress"] > 0) {



                if ($ManagerMedicoMisPacientes->is_paciente_sin_cargo($consulta["paciente_idpaciente"], $request["medico_idmedico"])) {
                    $request["precio_tarifa"] = 0;
                } else {
                    $request["precio_tarifa"] = (int) $preferencia["valorPinesConsultaExpress"];
                }

                $request["consulta_step"] = 3;


                return parent::update($request, $request["idconsultaExpress"]);
            } else {
                $this->setMsg(["msg" => "Error. El médico no posee configurada el precio de la consulta express", "result" => false]);

                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se ha seleccionado el medico", "result" => false]);

            return false;
        }
    }

    /*     * Metodo que crea una consulta express sin pasar por el proceso de busqueda , seleccionando directamente un medico
     * viene del listado de profesionales frecuentes o la ficha del medico y para ser creada directamente a ese profesional       
     * o  viene de profesonales en la red y se selecciona solo un medico del listado
     * @param type $request
     * @return boolean
     */

    public function set_medico_consultaexpress($request) {


        $request["consulta_step"] = 3;
        if ($request["medico_idmedico"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el medico"]);
            return false;
        }
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($request["medico_idmedico"]);
        //verificamos si el medico  acepta CE
        if ($preferencia["valorPinesConsultaExpress"] == "") {

            $this->setMsg(["result" => false, "msg" => "El médico no ofrece servicio de Consulta Express"]);
            return false;
        }

        //verificamos si el medico solo acepta CE a  sus pacientes
        if ($preferencia["pacientesConsultaExpress"] == 2) {
            //verificamos que sea un paciente frecuente del medico
            $frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($request["medico_idmedico"], $idpaciente);
            if (!$frecuente) {
                $this->setMsg(["result" => false, "msg" => "El médico solo ofrece servicio de Consulta Express a sus pacientes frecuentes"]);
                return false;
            }
        }
//si no viene el id de consultaexpres la debemos crear, porque viene del listado de profesionales frecuentes o la ficha del medico
        //para ser creada directamente a ese profesional sin pasar por el proceso de busqueda 
        if ((!isset($request["idconsultaExpress"])) || $request["idconsultaExpress"] == "") {
            $request["paciente_idpaciente"] = $idpaciente;
            $request["estadoConsultaExpress_idestadoConsultaExpress"] = 6;
            $request["tipo_consulta"] = 1;


            $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"]);
            if ($medico["active"] != 1 || $medico["validado"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
                return false;
            }

//verificamos si el paciente puede hacer consultas al medico segun su pais
            if ($paciente["pais_idpais"] == 1 && $paciente["pais_idpais_trabajo"] != 2 && $medico["pais_idpais"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Usted solo puede consultar a médicos de Francia"]);
                return false;
            }
//verificamos si el paciente es sin cargo
            $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
            if ($ManagerMedicoMisPacientes->is_paciente_sin_cargo($idpaciente, $medico["idmedico"])) {

                $request["precio_tarifa"] = 0;
            } else {
                //obtnememos la tarifa del medico
                $request["precio_tarifa"] = $preferencia["valorPinesConsultaExpress"];
            }


            $rdo = $this->deleteBorrador($idpaciente);
            $rdo1 = $this->process($request);
            if ($rdo && $rdo1) {
                $this->setMsg(["result" => true, "msg" => "Consulta Express creada con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
                return false;
            }
        } else {
            //si esta seteado el id de la CE, es una consulta ya existente, de profesonales en la red 
            //que se selecciona solo un medico del listado
            $request["ids_medicos_bolsa"] = "," . $request["medico_idmedico"] . ",";
            //obtnememos la tarifa del medico
            $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"]);
            if ($medico["active"] != 1 || $medico["validado"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
                return false;
            }
            unset($request["medico_idmedico"]);
            $rdo = $this->update($request, $request["idconsultaExpress"]);

            //actualizamos el filtro de busqueda con la tarifa del medico
            $ManagerFiltrosBusquedaConsultaExpress = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");
            $filtro = $ManagerFiltrosBusquedaConsultaExpress->getByField("consultaExpress_idconsultaExpress", $request["idconsultaExpress"]);
            $rdo1 = $ManagerFiltrosBusquedaConsultaExpress->update(["rango_maximo" => $preferencia["valorPinesConsultaExpress"], "rango_minimo" => $preferencia["valorPinesConsultaExpress"]], $filtro["idfiltrosBusquedaConsultaExpress"]);

            if ($rdo && $rdo1) {
                $this->setMsg(["result" => true, "msg" => "Consulta Express creada con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
                return false;
            }
        }
    }

    /*     * Metodo que cancela el pago de una consulta express, para retornar al paso de seleccion de medico
     * 
     * @param type $request
     */

    public function cancelarPago($request) {

        if ($request["idconsultaExpress"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);

            return false;
        } else {
            return parent::update(["medico_idmedico" => "", "ids_medicos_bolsa" => "", "precio_tarifa" => "", "consulta_step" => 1], $request["idconsultaExpress"]);
        }
    }

    /*
     * Metodo que confirma el pago de la consulta express seteando el paso siguiente
     * 
     * @param type $request
     */

    public function confirmarPago($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;

        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idconsultaExpress"]);

        if ($request["idconsultaExpress"] == "" || $consulta["paciente_idpaciente"] != $idpaciente || $consulta["estadoConsultaExpress_idestadoConsultaExpress"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
            return false;
        }

        $this->db->StartTrans();

        //Fechas de vencimiento
        $request["fecha_inicio"] = date("Y-m-d H:i:s");
        if ($consulta["tipo_consulta"] == "0") {
            //Profesionales en la red
            $request["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_CE_RED . " hour", strtotime($request["fecha_inicio"]));
        } else {
            //Profesionales frecuentes
            $request["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_CE_FRECUENTES . " hour", strtotime($request["fecha_inicio"]));
        }

        //Confirmada publicada
        $request["consulta_step"] = 5;

        $rdo = parent::update($request, $request["idconsultaExpress"]);


        if ($rdo) {
            $mis_pacientes = true;
            if ($consulta["tipo_consulta"] == "0") {
                //Profesionales en la red, es el rango máximo de filtro
                $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $request["idconsultaExpress"]);
                $request["rango_maximo"] = $filtro["rango_maximo"];
            } else {
                //Precio de la tarifa del médico
                $request["precio_tarifa"] = $consulta["precio_tarifa"];
                //insertamos el paciente al medico para que pueda visualiar el PF salud
                $mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $consulta["medico_idmedico"], "paciente_idpaciente" => $consulta["paciente_idpaciente"]]);
                $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert(["medico_idmedico" => $consulta["medico_idmedico"], "paciente_idpaciente" => $consulta["paciente_idpaciente"]]);
            }



            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");

            $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionCE($request);
            if ($movimiento_cuenta) {

                $cambio_estado = $this->cambiarEstado(["estadoConsultaExpress_idestadoConsultaExpress" => 1, "idconsultaExpress" => $request["idconsultaExpress"]]);

                if ($cambio_estado && $mis_pacientes) {
                    $this->setMsg(["msg" => "La Consulta Express fue creada con éxito", "result" => true]);


                    //enviamos el mail al/los medicos asociados 
                    $this->enviarMailNuevaCE($request["idconsultaExpress"]);
                    $this->enviarSMSNuevaCE($request["idconsultaExpress"]);

                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Consulta publicada con éxito", "result" => true]);

                    //evento de cambio de estado
                    $client = new XSocketClient();
                    $client->emit('cambio_estado_consultaexpress_php', $consulta);
                    //evento de nueva consulta en la red
                    if ($consulta["tipo_consulta"] == "0") {

                        //$client->emit('cambio_estado_consultaexpress_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                        //emitimos una notificacion a los medicos de la red seleccionados
                        if ($consulta["ids_medicos_bolsa"] != "") {
                            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";

                            if ($filtro["especialidad_idespecialidad"] != "") {
                                $especialidad = $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]);
                                $nombre_categoria = $especialidad["especialidad"];
                            } else if ($filtro["idprograma_categoria"] != "") {
                                $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($filtro["idprograma_categoria"]);
                                $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
                                $nombre_categoria = "{$programa_salud["programa_salud"]} - {$programa_categoria["programa_categoria"]}";
                            } else if ($filtro["idprograma_salud"] != "") {
                                $programa_salud = $this->getManager("ManagerProgramaSalud")->get($filtro["idprograma_salud"]);
                                $nombre_categoria = $programa_salud["programa_salud"];
                            }

                            $notify["text"] = "Nouvelle demande: " . $nombre_categoria;
                            $notify["type"] = "nueva-ce-red";
                            $notify["style"] = "consulta-express";

                            $ids_medicos = explode(',', $consulta["ids_medicos_bolsa"]);
                            foreach ($ids_medicos as $id) {
                                if ($id != "") {
                                    $notify["medico_idmedico"] = $id;
                                    $client->emit('notify_php', $notify);
                                }
                            }
                        }
                    } else {
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Nouvelle demande par Tchat";
                        $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                        $notify["type"] = "nueva-ce";
                        $notify["id"] = $request["idconsultaExpress"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);
                    }

                    return $request["idconsultaExpress"];
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    //El mensaje fue seteado en el método "cambiarEstado"
                    return false;
                }
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                //Si se produjo un error, seteo el mensaje de error con el de movimiento de la cuenta
                $this->setMsg($ManagerMovimientoCuenta->getMsg());
                return false;
            }
        } else {

            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo insertar la consulta express", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que emite un evento al servidor de websockets para obtener el contador de cantidades de consultas
     */
    public function obtener_contador_consultasexpress_socket() {

        $client = new XSocketClient();
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $client->emit('cambio_estado_consultaexpress_php', ["medico_idmedico" => $idmedico]);

        $this->setMsg(["msg" => "Mensaje creado con exito", "result" => true]);
        return true;
    }

    /**
     * Método que inserta el texto de la consulta express por parte de un paciente
     * Tener en cuenta que la consulta express podrá a todos los profesionales de la red o no...
     * @param type $request
     */
    public function publicarConsultaExpress($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;
        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idconsultaExpress"]);

        if ($request["idconsultaExpress"] == "" || $consulta["paciente_idpaciente"] != $idpaciente || $consulta["estadoConsultaExpress_idestadoConsultaExpress"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
            return false;
        }

        if ($request["motivoConsultaExpress_idmotivoConsultaExpress"] == "") {
            $this->setMsg(["result" => false, "msg" => "Seleccione el motivo de su consulta"]);
            return false;
        }

        if (strlen($request["mensaje"]) > 800) {
            $this->setMsg(["result" => false, "msg" => "Ha excedido la longitud de mensaje"]);
            return false;
        }

        $this->db->StartTrans();
        if ($request["acceso_perfil_salud"] == "1") {
            //actualizamos la privacidad del PS
            if ($consulta["tipo_consulta"] == "1") {
                $record["perfil-privado"] = 1;
            } else {
                $record["perfil-privado"] = 2;
            }


            $record["idpaciente"] = $idpaciente;
            $rdo_priv = $this->getManager("ManagerPaciente")->changePrivacidad($record);
            if (!$rdo_priv) {
                $this->setMsg(["result" => false, "msg" => "No se pudo cambiar la privacidad de su Perfil de Salud"]);
                $this->db->FailTrans();
                return false;
            }
        }
        //limpiamos el mensaje de publicacion previo si la consulta estaba en borrador
        $this->db->Execute("delete from mensajeconsultaexpress where consultaExpress_idconsultaExpress=" . $request["idconsultaExpress"]);

        //Debo insertar el mensaje
        $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
        $request["consultaExpress_idconsultaExpress"] = $request["idconsultaExpress"];
        $insert_mensaje = $ManagerMensajeConsultaExpress->insert($request);

        if (!$insert_mensaje) {
            $this->setMsg(["msg" => "Error. No se pudo insertar el mensaje de la consulta express", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }


        $request["estadoConsultaExpress_idestadoConsultaExpress"] = 6;
        $request["consulta_step"] = 4;
        $rdo = parent::update($request, $request["idconsultaExpress"]);

        if ($rdo) {
            $this->setMsg(["msg" => "Mensaje creado con exito", "result" => true]);
            $this->db->CompleteTrans();
            return $request["idconsultaExpress"];
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();

            $this->setMsg(["msg" => "Error. No se pudo insertar la consulta express", "result" => false]);
            return false;
        }
    }

    /**
     * Metodo que carga el costo de la consulta express a los consumos del plan del prestador
     * Verifica si tiene disponibles consultas sin cargo, o si se debe pagar la tarifa del prestador
     * 
     */

    /**
     * Finalización de la consulta, 
     * La finalización de la consulta, se hará cuando el médico cierre la consulta al paciente.. 
     * DP, le deberá pagar al médico el dinero correspondiente
     * @param type $request
     */
    public function finalizarConsultaExpress($request) {

        if ((int) $request["idconsultaExpress"] > 0) {
            $consulta_express = $this->get($request["idconsultaExpress"]);
            if ($consulta_express) {

                $this->db->StartTrans();

                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $consulta_express["medico_idmedico"] || $consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != 4) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la consulta express seleccionada", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }

                //DoctorPlus retendrá el dinero perteneciente a DP
                if ($consulta_express["prestador_idprestador"] != "") {
                    $prestador = $this->getManager("ManagerPrestador")->get($consulta_express["prestador_idprestador"]);
                    if ($prestador["comision_dp"] != "") {
                        $comision_doctor_plus = $consulta_express["precio_tarifa_prestador"] * $prestador["comision_dp"] / 100;
                    } else {
                        $comision_doctor_plus = 0;
                    }

                    $update_consulta_express = parent::update([
                                "comision_doctor_plus" => $comision_doctor_plus
                                    ], $consulta_express[$this->id]);
                    if (!$update_consulta_express) {
                        $this->setMsg(["msg" => "Error. No se pudo actualizar la video consulta", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();

                        return false;
                    }
                } else {
                    //Le tengo que agregar el monto a DP si la cuenta del médico es gratuita
                    $medico = $this->getManager("ManagerMedico")->get($idmedico);
                    if ($medico && (int) $medico["planProfesional"] == 0) {
                        //Le tengo que sacar la comision
                        $comision_doctor_plus = $consulta_express["precio_tarifa"] * COMISION_CE / 100;
                        $update_consulta_express = parent::update([
                                    "comision_doctor_plus" => $comision_doctor_plus
                                        ], $consulta_express[$this->id]);
                        if (!$update_consulta_express) {
                            $this->setMsg(["msg" => "Error. No se pudo actualizar la consulta express", "result" => false]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();

                            return false;
                        }
                    }
                }




                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");

                $finalizacion_cuenta = $ManagerMovimientoCuenta->processFinalizacionCE($consulta_express);
                $perfil_salud = $this->getManager("ManagerPerfilSaludEstudios")->processFromConsultaExpress($consulta_express["idconsultaExpress"]);

                if ($finalizacion_cuenta && $perfil_salud) {
                    //MOdifico el estado a finalizado
                    $this->setMsg(["msg" => "La consulta express fue finalizada con éxito", "result" => true]);

                    $this->db->CompleteTrans();



                    return $consulta_express[$this->id];
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();

                    if (!$finalizacion_cuenta) {
                        //Retorno el mensaje de error del manager de movimiento cuenta,
                        $this->setMsg($ManagerMovimientoCuenta->getMsg());
                    } else {
                        $this->setMsg(["msg" => "Error. No se pudo procesar los estudios e imagenes", "result" => false]);
                    }
                    return false;
                }
            }
        }
        //Error no hay consulta express
        $this->setMsg(["msg" => "Error. No se pudo procesar la consulta express.", "result" => false]);

        return false;
    }

    /**
     * Rechazo de la consulta express, 
     * se debe cambiar el estado de la consulta
     * enviar al process de los movimientos de la consulta express
     * @param type $request
     */
    public function rechazarConsultaExpress($request) {
        if ((int) $request["consultaExpress_idconsultaExpress"] > 0 && (int) $request["motivoRechazo_idmotivoRechazo"] > 0) {
            $consulta_express = $this->get($request["consultaExpress_idconsultaExpress"]);

            //validamos la existencia del la consulta express pendiente
            if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != "1") {
                $this->setMsg(["msg" => "Error. La consulta no se encuentra pendiente", "result" => false]);
                return false;
            }

            if ($consulta_express) {

                $this->db->StartTrans();

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $rechazar_consulta = $ManagerMovimientoCuenta->processRechazarPublicacionCE($consulta_express);
                if ($rechazar_consulta) {
                    if ($request["mensaje"] != "") {
                        //insertamos el mensaje del medico
                        $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
                        $request["repuesta_desde_consulta"] = 1;
                        $request["rechazar"] = 1;
                        $mensaje = $ManagerMensajeConsultaExpress->insert($request);
                        if (!$mensaje) {
                            $this->setMsg(["msg" => "Error. No se pudo declinar la consulta express.",
                                "result" => false
                            ]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                    //cambiamos el estado a declinada
                    $cambio_estado = $this->cambiarEstado([
                        "estadoConsultaExpress_idestadoConsultaExpress" => 3,
                        "idconsultaExpress" => $consulta_express[$this->id],
                        "motivoRechazo_idmotivoRechazo" => $request["motivoRechazo_idmotivoRechazo"]]);
                    if ($cambio_estado) {

                        $this->enviarMailRechazoCE($request["consultaExpress_idconsultaExpress"]);
                        $this->enviarSMSRechazoCE($request["consultaExpress_idconsultaExpress"]);

                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
                        //notify
                        $paciente = $this->getManager("ManagerPaciente")->get($consulta_express["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Conseil décliné";
                        $notify["paciente_idpaciente"] = $consulta_express["paciente_idpaciente"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);
                        $this->setMsg(["msg" => "La consulta express fue declinada con éxito", "result" => true]);



                        // <-- LOG
                        $log["data"] = "reason for declining, date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
                        $log["page"] = "Conseil";
                        $log["action"] = "val"; //"val" "vis" "del"
                        $log["purpose"] = "Decline Conseil request RECEIVED";

                        $ManagerLog = $this->getManager("ManagerLog");
                        $ManagerLog->track($log);
                        // 

                        return $consulta_express[$this->id];
                    } else {
                        //El mensaje fue seteado en el método "cambiarEstado"
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                } else {
                    $this->setMsg($ManagerMovimientoCuenta->getMsg());
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
        }
        $this->setMsg(["msg" => "Error. No se pudo declinar la consulta express.", "result" => false]);
        return false;
    }

    /**
     * Método que realiza la aceptación de la consulta express por parte del médico
     * @param type $request
     */
    public function aceptarConsultaExpress($request) {

        if ($request[$this->id] != "") {

            $request["consultaExpress_idconsultaExpress"] = $request[$this->id];
            $this->db->StartTrans();

            $consulta_express = $this->get($request[$this->id]);
            if ($consulta_express) {
                $fecha_actual = strtotime(date("Y-m-d H:i:s"));


                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $consulta_express["medico_idmedico"] || $consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] != 1) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la consulta express seleccionada", "result" => false]);
                    $this->db->FailTrans();
                    return false;
                }

                /**
                 * Controla las fechas 
                 */
                if ($consulta_express["ids_medicos_bolsa"] != "") {
                    $update_consulta = parent::update(["tomada" => 0, "fecha_toma" => "", "ids_medicos_bolsa" => ""], $consulta_express[$this->id]);


                    //Si la consulta fue a la bolsa, la fecha de vencimiento es la fecha_toma
                    if ($consulta_express["fecha_toma"] == "" || $consulta_express["tomada"] == 0) {
                        $this->setMsg(["msg" => "Error. Ya expiró el tiempo de la consulta express tomada", "result" => false]);
                        $this->db->FailTrans();
                        return false;
                    }
                    $fecha_vencimiento = strtotime($consulta_express["fecha_vencimiento"]);
                } else {
                    $fecha_vencimiento = strtotime($consulta_express["fecha_vencimiento"]);
                }


                if ($fecha_actual > $fecha_vencimiento) {
                    $this->setMsg(["msg" => "Error. Ya pasó el período de publicación de una consulta", "result" => false]);
                    $this->db->FailTrans();
                    return false;
                }

                //Debo insertar el mensaje del médico, si no hay mensaje que retorne falso
                $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
                $mensaje = $ManagerMensajeConsultaExpress->insert($request);
                if (!$mensaje) {
                    $this->setMsg(["msg" => "Error. No se pudo insertar el mensaje de la consulta express", "result" => false]);
                    $this->db->FailTrans();
                    return false;
                }

                $cambio_estado = $this->cambiarEstado(
                        ["estadoConsultaExpress_idestadoConsultaExpress" => 2, "idconsultaExpress" => $consulta_express[$this->id]]
                );
                if ($cambio_estado) {

                    $this->setMsg(["msg" => "La consulta express fue aceptada con éxito", "result" => true]);

                    $this->db->CompleteTrans();


                    $client = new XSocketClient();
                    $client->emit("cambio_estado_consultaexpress_php", $consulta_express);
                    //notify
                    $paciente = $this->getManager("ManagerPaciente")->get($consulta_express["paciente_idpaciente"]);

                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                    $notify["text"] = "Nouveau message";
                    $notify["type"] = "mensaje-ce-paciente";
                    $notify["id"] = $consulta_express["idconsultaExpress"];
                    $notify["paciente_idpaciente"] = $consulta_express["paciente_idpaciente"];
                    $notify["style"] = "consulta-express";
                    $client->emit('notify_php', $notify);

                    return $consulta_express[$this->id];
                } else {
                    $this->db->FailTrans();
                    //El mensaje fue seteado en el método "cambiarEstado"
                    return false;
                }
            }
        }
    }

    /*     * Metodo que realiza la toma 
     * 
     * @param type $idconsultaExpress
     */

    public function tomarConsultaExpress($idconsultaExpress) {

        $consulta_express = parent::get($idconsultaExpress);
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        if ($consulta_express["idconsultaExpress"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);
            return false;
        }
        if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] == "2") {

            $this->setMsg(["msg" => "Error. La consulta ya ha sido tomada por otro profesional", "result" => false, "abierta" => 1]);
            return false;
        }
        $this->db->StartTrans();
        if ($consulta_express["tomada"] == 1) {
            $fecha_actual = strtotime(date("Y-m-d H:i:s"));
            $fecha_vencimiento_toma = strtotime($consulta_express["fecha_vencimiento_toma"]);

            //si ya vencio la toma la actualizamos
            if ($fecha_actual > $fecha_vencimiento_toma) {
                $vencimiento = date_create($consulta_express["fecha_vencimiento"]);
                $fecha_toma = date_create($consulta_express["fecha_toma"]);
                $intervalo = date_diff($vencimiento, $fecha_toma);

                $add_mins = $intervalo->format('%i');
                $add_sec = $intervalo->format('%s');

                $record["fecha_vencimiento"] = strtotime('+' . $add_mins . 'minutes ' . $add_sec . ' seconds', strtotime(date("Y-m-d H:i:s")));

                $rdo1 = parent::update($record, $idconsultaExpress);

                if (!$rdo1) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                }
            } else {//sino retornamos el medio que la tomo
                $ManagerMedico = $this->getManager("ManagerMedico");
                $medico_tomada = $ManagerMedico->get($consulta_express["medico_idmedico"], true);
                $medico_tomada["imagen"] = $ManagerMedico->getImagenMedico($consulta_express["medico_idmedico"]);
                $medico_tomada["segundos_diferencia_toma"] = $fecha_vencimiento_toma - $fecha_actual;






                $this->setMsg(["msg" => "La consulta ya ha sido tomada", "result" => true, "tomada" => 1, "medico_tomada" => $medico_tomada]);
                return false;
            }
        }



        $record["tomada"] = 1;
        $record["fecha_toma"] = date("Y-m-d H:i:s");

        $fecha_actual = strtotime(date("Y-m-d H:i:s"));
        $fecha_vencimiento = strtotime($consulta_express["fecha_vencimiento"]);

        if ($fecha_actual > $fecha_vencimiento) {
            $this->setMsg(["msg" => "Error. Ya pasó el período de publicación de una consulta", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $record["fecha_vencimiento_toma"] = date('Y-m-d H:i:s', strtotime('+10 minute'));
        $record["medico_idmedico"] = $idmedico;
        $record["leido_medico"] = 0;

        //seteamos el costo si no es del prestador
        if ($consulta_express["prestador_idprestador"] == "") {
            $medico = $this->getManager("ManagerMedico")->get($idmedico);
            $preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);
            $record["precio_tarifa"] = $preferencia["valorPinesConsultaExpress"];

            if ($record["precio_tarifa"] == "") {
                $this->setMsg(["msg" => "Error. No se pudo tomar la consulta", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        $rdo = parent::update($record, $idconsultaExpress);
        if ($rdo) {
            $this->setMsg(["msg" => "La consulta ha sido tomada con exito. Verifique sus consultas pendientes", "result" => true]);

            $this->db->CompleteTrans();
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo tomar la consulta", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /*     * Metodo que rechaza la toma de consulta express y la devuelve a la lista de pendientes
     * 
     * @param type $idconsultaExpress
     */

    public function rechazarTomaConsultaExpress($idconsultaExpress) {

        $consulta_express = parent::get($idconsultaExpress);
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        if ($consulta_express["idconsultaExpress"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);
            return false;
        }
        if ($consulta_express["estadoConsultaExpress_idestadoConsultaExpress"] == "2") {

            $this->setMsg(["msg" => "Error. La consulta ya ha sido tomada por otro profesional", "result" => false]);
            return false;
        }

        if ($consulta_express["tomada"] == "1" && $consulta_express["medico_idmedico"] != $idmedico) {

            $this->setMsg(["msg" => "Error. La consulta ya ha sido tomada por otro profesional", "result" => false]);
            return false;
        }

        //actualizamos el tiempo que le queda
        $record["fecha_vencimiento_toma"] = "";
        $record["fecha_toma"] = "";
        $record["medico_idmedico"] = "";
        $record["tomada"] = 0;
        $record["precio_tarifa"] = "";

        $rdo = parent::update($record, $idconsultaExpress);

        if ($rdo) {
            $this->setMsg(["msg" => "La consulta ha sido declinada con éxito", "result" => true]);
            // <-- LOG
            $log["data"] = "reason for declining, date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
            $log["page"] = "Conseil";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Decline Conseil request RECEIVED";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            return true;
        } else {
            $this->setMsg(["msg" => "La consulta no ha podido declinarse", "result" => false]);

            return false;
        }
    }

    /**
     * Método que obtiene la información de las consultas express pertenecientes a un determinado período y a un médico
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */
    public function getInfoConsultaExpressPeriodo($fecha_inicio, $fecha_fin, $idmedico) {
        $query = new AbstractSql();

        // $query->setSelect("COUNT(idconsultaExpress) as cantidad_consultas_express, SUM(IFNULL(precio_tarifa,0))+SUM(IFNULL(precio_tarifa_prestador,0)) as monto_tarifa,SUM(comision_doctor_plus) as monto_comision_doctor_plus ");
        $query->setSelect("COUNT(idconsultaExpress) as cantidad_consultas_express, SUM(IFNULL(precio_tarifa,0)) as monto_tarifa,SUM(IFNULL(comision_doctor_plus,0))+SUM(IFNULL(comision_prestador,0)) as monto_comision_doctor_plus ");

        $query->setFrom("$this->table");

        $query->setWhere("fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin'");

        $query->addAnd("medico_idmedico = $idmedico");

        $query->addAnd("estadoConsultaExpress_idestadoConsultaExpress = 4");



        $row = $this->db->GetRow($query->getSql());

        return $row;
    }

    /*     * Metodo que setea el flag acreditado en las consultas express del periodo que han finalizado y se acreditan en la cuenta medico
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */

    public function acreditarConsultaExpressFinalizadaPeriodo($fecha_inicio, $fecha_fin, $idmedico) {
        return $this->db->Execute("update $this->table set acreditada=1 where estadoConsultaExpress_idestadoConsultaExpress = 4 and acreditada=0 "
                        . " AND fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin' AND medico_idmedico = $idmedico");
    }

    /*     * Metodo para crear una consulta express directamente a un medico sin pasar por la busqueda
     * se accede por el icono de consulta expres del medico 
     *  
     */

    public function createConsultaExpressByMedico($idmedico) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $borrador = $this->getConsultaExpressBorrador($idpaciente);

        if ($borrador["idconsultaExpress"] != "") {
            $this->setMsg(["msg" => "Ud. tiene una Consulta Express en proceso", "result" => false, "borrador" => 1]);
            return false;
        }
        $record["medico_idmedico"] = $idmedico;
        $record["consulta_step"] = 3;
        $record["paciente_idpaciente"] = $idpaciente;
        $record["tipo_consulta"] = 1;
        $record["estadoConsultaExpress_idestadoConsultaExpress"] = 6; //borrador
        $ManagerPreferencia = $this->getManager("ManagerPreferencia");
        $preferencia = $ManagerPreferencia->getPreferenciaMedico($idmedico);
        $record["precio_tarifa"] = (int) $preferencia["valorPinesConsultaExpress"];

        $id = parent::insert($record);
        //creamos el numero de consulta express formateado
        $record["numeroConsultaExpress"] = STR_PAD($id, 7, "0", STR_PAD_LEFT);
        $rdo = parent::update($record, $id);
        if ($rdo) {
            $this->setMsg(["msg" => "Consulta express creada con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se pudo crear la consulta express", "result" => false]);
            return false;
        }
    }

    /*     * Incrementa el contador de visualizaciones de consultas express pendientes
     * 
     * @param type $idconsultaExpress
     */

    public function marcarVisto($idconsultaExpress) {

        $this->db->StartTrans();
        $update = "UPDATE $this->table set visualizaciones = (visualizaciones + 1)  where idconsultaExpress = $idconsultaExpress";

        $rdo = $this->db->Execute($update);

        if ($rdo) {
            $this->setMsg(["result" => true]);
            $this->db->CompleteTrans();
            return true;
        } else {
            $this->setMsg(["result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /*     * Metodo que retorna el detalle de un listado de consultas express realizadas por el medico
     * en un periodo
     * @param array $request
     * @param type $idpaginate
     * @return type
     */

    public function getListadoPaginadoDetalleConsultasExpressXPeriodo($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
        $periodo_pago = $ManagerPeriodoPago->get($request["idperiodoPago"]);

        $fecha_fin = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
        $fecha_inicio = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table ce");
        $query->setWhere("estadoConsultaExpress_idestadoConsultaExpress=4 AND ce.fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin' AND medico_idmedico = $idmedico");


        $listado = $this->getListPaginado($query, $idpaginate);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerPrestador = $this->getManager("ManagerPrestador");
        if ($listado["rows"] && count($listado["rows"]) > 0) {
            foreach ($listado["rows"] as $key => $CE) {
                if ($CE["prestador_idprestador"] != "") {
                    $listado["rows"][$key]["prestador"] = $ManagerPrestador->get($CE["prestador_idprestador"]);
                }
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($CE["paciente_idpaciente"]);
                $listado["rows"][$key]["fecha_fin_format"] = fechaToString($CE["fecha_fin"]);
            }
        }
        return $listado;
    }

    /*     * Metodo que retorna un array con las CE por especialidad ordenadas descendientemente
     * 
     */

    public function getCantidadConsultaExpressXEspecialidad($idespecialidad = null) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad, idespecialidad,especialidad");
        $query->setFrom("consultaexpress ce
                inner join filtrosbusquedaconsultaexpress f on (f.consultaExpress_idconsultaExpress=ce.idconsultaExpress)
                    inner join especialidad es on (es.idespecialidad=f.especialidad_idespecialidad)");
        $query->setWhere("ce.estadoConsultaExpress_idestadoConsultaExpress=1");
        if ($idespecialidad != NULL) {
            $query->addAnd("idespecialidad=$idespecialidad");
        }
        $query->addAnd("tipo_consulta=0");
        $query->setGroupBy("idespecialidad");
        $query->setOrderBy("cantidad DESC");

        return $this->getList($query);
    }

    /**
     * Eliminación de las vencidas del listado
     * se marcará el flag "visualizar_consulta_medico"
     * @param type $request
     */
    public function eliminar_from_vencidas($request) {
        if ((int) $request["id"] > 0) {
            $consulta_express = $this->get($request["id"]);
            if ($consulta_express && $consulta_express["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {
                $update = parent::update(["visualizar_consulta_medico" => 0], $consulta_express[$this->id]);

                if ($update) {
                    $this->setMsg(["msg" => "Eliminada con éxito", "result" => true]);
                    return $update;
                }
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo eliminar la consulta", "result" => false]);
        return false;
    }

    /**
     * Eliminación de las vencidas del listado
     * se marcará el flag "visualizar_consulta_paciente"
     * @param type $request
     */
    public function eliminar_from_vencidas_paciente($request) {

        if ((int) $request["id"] > 0) {
            $consulta_express = $this->get($request["id"]);
            if ($consulta_express) {
                $update = parent::update(["visualizar_consulta_paciente" => 0], $consulta_express[$this->id]);

                if ($update) {
                    $this->setMsg(["msg" => "Eliminada con éxito", "result" => true]);

                    // <-- LOG
                    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
                    $log["page"] = "Conseil";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Delete ConsultationExpress request EXPIRED/DECLINED/FINALIZED";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 


                    return $update;
                }
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo eliminar la consulta", "result" => false]);
        return false;
    }

    /**
     * Método utilizado para extender la videoconsulta desde el paciente
     * @param type $request
     */
    public function extender_from_vencidas_prestador($request) {

        if ((int) $request["id"] > 0) {

            $consulta = $this->get($request["id"]);
            $ahora = date("Y-m-d H:i:s");

            //Extiendo el plazo del tiempo...
            $update = array(
                "estadoConsultaExpress_idestadoConsultaExpress" => 1, //Pendiente
                "fecha_inicio" => $ahora,
                "fecha_fin" => "",
                "fecha_ultimo_mensaje" => $ahora,
                "visualizaciones" => 0,
                "leido_paciente" => 0,
                "leido_medico" => 0,
                "visualizar_consulta_paciente" => 1,
                "visualizar_consulta_medico" => 1
            );

            //Fechas de vencimiento
            if ($consulta["tipo_consulta"] == "0") {
                //Profesionales en la red
                $update["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_CE_RED . " hour", strtotime($ahora));
            } else {
                //Profesionales frecuentes
                $update["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_CE_FRECUENTES . " hour", strtotime($ahora));
            }
            //actualizamos la consulta
            $this->db->StartTrans();
            $update_ce = parent::update($update, $request["id"]);


            if ($update_ce) {

                if ($consulta["tipo_consulta"] == "0") {
                    //Profesionales en la red, es el rango máximo de filtro
                    $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $consulta["idconsultaExpress"]);
                }
                //descontamos el dinero de la consulta para republicarla
                $recordMovimiento["idconsultaExpress"] = $request["id"];
                $recordMovimiento["paciente_idpaciente"] = $consulta["paciente_idpaciente"];

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionCE($recordMovimiento);
                //fin procesamiento decontar dinero


                if ($movimiento_cuenta) {

                    //enviamos el mail al medico si esta dirgida a un profesional
                    if ($consulta["medico_idmedico"] != "" && $consulta["tipo_consulta"] == "1") {
                        $this->enviarMailNuevaCE($consulta["idconsultaExpress"]);
                        $this->enviarSMSNuevaCE($consulta["idconsultaExpress"]);
                    }
                    $this->actualizarEstados();
                    $this->setMsg(["msg" => "Se extendió el plazo de la consulta", "result" => true]);
                    $this->db->CompleteTrans();
                    $client = new XSocketClient();
                    $client->emit("cambio_estado_consultaexpress_php", $consulta);
                    //evento de nueva consulta en la red
                    if ($consulta["tipo_consulta"] == "0") {

                        $client->emit('cambio_estado_consultaexpress_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                    } else {
                        //notify
                        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                        $notify["text"] = "Nouvelle demande par Tchat";
                        $notify["type"] = "nueva-ce";
                        $notify["id"] = $request["idconsultaExpress"];
                        $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                        $notify["style"] = "consulta-express";
                        $client->emit('notify_php', $notify);
                    }
                    $this->actualizarEstados();


                    return true;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    //Si se produjo un error, seteo el mensaje de error con el de movimiento de la cuenta
                    $this->setMsg($ManagerMovimientoCuenta->getMsg());
                    return false;
                }
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error, no se pudo extender el plazo de la consulta", "result" => false]);
                return false;
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo extender el plazo de la consulta", "result" => false]);
        return false;
    }

    /**
     * Método utilizado para extender la consulta express desde el paciente
     * @param type $request
     */
    public function extender_from_vencidas_paciente($request) {

        if ((int) $request["id"] > 0) {

            $consulta = $this->get($request["id"]);
            $ahora = date("Y-m-d H:i:s");

            //Extiendo el plazo del tiempo...
            $update = array(
                "estadoConsultaExpress_idestadoConsultaExpress" => 6, //Borrador
                "fecha_inicio" => $ahora,
                "consulta_step" => 4,
                "fecha_fin" => "",
                "visualizaciones" => 0,
                "leido_paciente" => 0,
                "leido_medico" => 0,
                "fecha_ultimo_mensaje" => $ahora,
                "visualizar_consulta_paciente" => 1,
                "visualizar_consulta_medico" => 1,
                "pago_stripe" => 0,
                "debito_plan_empresa" => 0,
                "stripe_payment_intent_id" => "",
                "stripe_payment_method" => ""
            );


            //Fechas de vencimiento
            if ($consulta["tipo_consulta"] == "0") {
                //Profesionales en la red

                $update["fecha_vencimiento"] = strtotime('+' . VENCIMIENTO_CE_RED . ' hour', strtotime($ahora));
            } else {
                //Profesionales frecuentes
                $update["fecha_vencimiento"] = strtotime('+' . VENCIMIENTO_CE_FRECUENTES . ' hour', strtotime($ahora));
            }

            //actualizamos la consulta
            $this->db->StartTrans();
            $update_ce = parent::update($update, $request["id"]);


            if ($update_ce) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Se extendió el plazo de la consulta", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error, no se pudo extender el plazo de la consulta", "result" => false]);
                return false;
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo extender el plazo de la consulta", "result" => false]);
        return false;
    }

    /**
     * Método utilizado para publicar la consulta express a otro profesional desde el paciente
     * @param type $request
     */
    public function republicar_from_vencidas_paciente($request) {

        $this->db->StartTrans();
        if ((int) $request["id"] > 0) {


            $ce = parent::get($request["id"]);

            $ce_borrador = $this->getConsultaExpressBorrador($ce["paciente_idpaciente"]);
            if ($ce_borrador) {
                //Se elimina la consulta que está en borrador
                $delete = parent::delete($ce_borrador[$this->id]);
                if (!$delete) {
                    $this->setMsg(["msg" => "Error, no se pudo republicar la consulta", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //Elimino la consulta from vencidas
            $eliminar_from_vencidas = $this->eliminar_from_vencidas_paciente($request);
            if (!$eliminar_from_vencidas) {
                $this->setMsg(["msg" => "Error, no se pudo republicar la consulta", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }


            /**
             * Creo el insert de la consulta express
             */
            $insert = [
                "paciente_idpaciente" => $ce["paciente_idpaciente"],
                "estadoConsultaExpress_idestadoConsultaExpress" => 6,
                "consulta_step" => 0,
                "motivoConsultaExpress_idmotivoConsultaExpress" => $ce["motivoConsultaExpress_idmotivoConsultaExpress"],
                "tipo_consulta" => $ce["tipo_consulta"],
                "republicacion" => $ce["numeroConsultaExpress"]
            ];

            $insert_ce = parent::insert($insert);
            $record["numeroConsultaExpress"] = STR_PAD($insert_ce, 7, "0", STR_PAD_LEFT);

            $upd = parent::update($record, $insert_ce);

            if ($upd) {

                //Clonado de mensajes
                $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");

                $primer_mensaje = $ManagerMensajeConsultaExpress->getPrimerMensaje($request["id"]);

                $rdo_clone = $ManagerMensajeConsultaExpress->cloneMensaje($primer_mensaje["idmensajeConsultaExpress"], $insert_ce);

                if ($rdo_clone) {

                    // <-- LOG
                    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
                    $log["page"] = "Conseil";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Republicate Conseil request EXPIRED";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 
                    $this->setMsg(["msg" => "La consulta fue republicada con éxito. ", "result" => true]);

                    $this->db->CompleteTrans();
                    $client = new XSocketClient();
                    $client->emit("cambio_estado_consultaexpress_php", $ce);


                    return true;
                }
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo republicar la consulta", "result" => false]);
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        return false;
    }

    /**
     * Método utilizado para republicar la consulta express desde el prestador a otro profesional
     * @param type $request
     */
    public function republicar_from_vencidas_prestador($request) {

        $this->db->StartTrans();
        if ((int) $request["id"] > 0) {

            $ce = parent::get($request["id"]);
            $request["motivoConsultaExpress_idmotivoConsultaExpress"] = $ce["motivoConsultaExpress_idmotivoConsultaExpress"];
            $request["paciente_idpaciente"] = $ce["paciente_idpaciente"];
            $request["republicacion"] = $ce["numeroConsultaExpress"];
            //Clonado de mensajes
            $ManagerMensajeConsultaExpress = $this->getManager("ManagerMensajeConsultaExpress");
            $primer_mensaje = $ManagerMensajeConsultaExpress->getPrimerMensaje($request["id"]);
            $request["mensaje"] = $primer_mensaje["mensaje"];


            $ce_borrador = $this->getConsultaExpressBorrador($ce["paciente_idpaciente"]);

            if ($ce_borrador) {

                //Se elimina la consulta que está en borrador
                $delete = parent::delete($ce_borrador[$this->id]);
                if (!$delete) {
                    $this->setMsg(["msg" => "Error, no se pudo republicar la Consulta Express", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //Elimino la consulta from vencidas

            $eliminar_from_vencidas = $this->eliminar_from_vencidas_paciente($request);
            if (!$eliminar_from_vencidas) {
                $this->setMsg(["msg" => "Error, no se pudo republicar la Consulta Express", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            /**
             * Creo la consulta express
             */
            $insert_ce = $this->crearConsultaExpressFromPrestador($request);
            if ($insert_ce) {
                $this->setMsg(["msg" => "La Consulta Express ha sido republicada con éxito", "result" => true]);

                $this->db->CompleteTrans();
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo recuperar la Consulta Express a republicar", "result" => false]);
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        return false;
    }

    /**
     * Método que envía el email de finalizacion de la consulta express..
     * Cuando finaliza la misma
     * @param type $idconsultaexpress
     * @return boolean
     */
    public function enviarMailFinalizacionCE($idconsultaexpress) {
        $consulta = $this->get($idconsultaexpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

        $ManagerMedico = $this->getManager("ManagerMedico");
        $consulta["medico"] = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $consulta["medico"]["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
        $consulta["motivoConsultaExpress"] = $this->getManager("ManagerMotivoConsultaExpress")->get($consulta["motivoConsultaExpress_idmotivoConsultaExpress"])["motivoConsultaExpress"];

        $idperfilsaludconsulta = $this->getIdConclusion($idconsultaexpress);

        //ojo solo arnet local
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Votre Conseil Nº" . $consulta["numeroConsultaExpress"] . " a déja été finalisé");

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("consulta_express", $consulta);
        $smarty->assign("idperfilsaludconsulta", $idperfilsaludconsulta);

        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/mensaje_finalizacion_consultaexpress.tpl"));


        $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);
        if ($paciente_titular["email"] != "") {
            $mEmail->addTo($paciente_titular["email"]);
            //header a todos los comentarios!
            if ($mEmail->send()) {
                return true;
            }
        }
        $this->setMsg(array("result" => false, "msg" => "No se pudo enviar el mensaje"));
        return false;
    }

    public function delete($id, $force) {

        // <-- LOG
        $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
        $log["page"] = "Home page (connected)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Cancel Conseil request with connected Frequent Professional";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 
        parent::delete($id, $force);
    }

    /*     * Metodo que elimina las consultas que quedan en estado borrador
     * 
     * @param type $idpaciente
     */

    public function deleteBorrador($idpaciente) {

        $rdo = $this->db->Execute("delete from $this->table where estadoConsultaExpress_idestadoConsultaExpress=6 and paciente_idpaciente=$idpaciente");
        return $rdo;
    }

    /*     * Metodo que retorocede a un paso especifico una consulta express, realizando las eliminaciones y cambios requeridos 
     * de los campos ingresados en los pasos posteriores al seleccionado
     * 
     */

    public function back_step($request) {

        $consulta = parent::get($request["idconsultaExpress"]);
        if ($request["idconsultaExpress"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);
            return false;
        }






        //verificamos que pertenezca al paciente
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta express", "result" => false]);
            return false;
        }
        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] != "6") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado borrador", "result" => false]);
            return false;
        }

        switch ((int) $request["step"]) {
            case 1:
                //verificamos que sea un step correcto
                if ($consulta["consulta_step"] == "2" || $consulta["consulta_step"] == "3" || $consulta["consulta_step"] == "4") {
                    $rdo1 = $result = $this->delete($request["idconsultaExpress"], true);
                    $rdo2 = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->deleteFiltrosBusqueda($request["idconsultaExpress"]);
                    break;
                } else {
                    $step_invalido = true;
                }
            case 2:
                if ($consulta["consulta_step"] == "3" || $consulta["consulta_step"] == "4") {
                    $request["medico_idmedico"] = "";
                    $request["ids_medicos_bolsa"] = "";
                    $request["precio_tarifa"] = "";
                    $request["consulta_step"] = 2;

                    $rdo1 = $this->update($request, $request["idconsultaExpress"]);
                    $rdo2 = true;
                    break;
                } else {
                    $step_invalido = true;
                }
            case 3:
                if ($consulta["consulta_step"] == "3" || $consulta["consulta_step"] == "4") {
                    $request["consulta_step"] = 3;
                    $rdo1 = $this->update($request, $request["idconsultaExpress"]);
                    $rdo2 = true;
                    break;
                } else {
                    $step_invalido = true;
                }
            default:
                $step_invalido = true;
                break;
        }
        if ($step_invalido) {
            $this->setMsg(["msg" => "Error. El paso indicado no es correcto", "result" => false]);
            return false;
        }
        if ($rdo1 && $rdo2) {
            return $rdo1;
        } else {
            $this->setMsg(["msg" => "Error al volver al paso indicado", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cancela una consulta express en estado pendiente y  realiza la devolucion del dinero
     * 
     * @param type $idconsultaExpress
     * @return boolean
     */

    public function cancelarConsultaExpressPendiente($idconsultaExpress) {

        $consulta = $this->get($idconsultaExpress);
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta express", "result" => false]);
            return false;
        }
        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] != "1") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado pendiente", "result" => false]);
            return false;
        }

        if ($consulta["tomada"] != "0") {
            $this->setMsg(["msg" => "La consulta está siendo respondida por un profesional", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $devolucion = $this->getManager("ManagerMovimientoCuenta")->processVencimientoCE(["idconsultaExpress" => $idconsultaExpress]);
        $delete = parent::update(["visualizar_consulta_paciente" => 0, "visualizar_consulta_medico" => 0, "estadoConsultaExpress_idestadoConsultaExpress" => 9], $idconsultaExpress);
        if ($devolucion && $delete) {

            if ($consulta["medico_idmedico"] != "") {
                $client = new XSocketClient();
                $client->emit("cambio_estado_consultaexpress_php", $consulta);


                //Enviamos mail al medico
                $this->enviarMailCancelacionConsulta($idconsultaExpress);

                //Enviamos sms al medico
                $this->enviarSMSCancelacionConsulta($idconsultaExpress);

                //enviamos la notificacion al medico
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseils";
                $notify["text"] = "Demande par Tchat annulée";
                $notify["type"] = "cancelar-ce";
                $notify["id"] = $consulta["idconsultaExpress"];
                $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                $notify["style"] = "consulta-express";
                $client->emit('notify_php', $notify);
            }
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha cancelado la Consulta Express. El importe de la misma ha sido devuelto a su cuenta", "result" => true]);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo cancelar la consulta express", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cancela una consulta express en estado pendiente y la republica cambiando la informacion
     *  tambien se realiza la devolucion del dinero
     * 
     * @param type $idconsultaExpress
     * @return boolean
     */

    public function cancelarRepublicarConsultaExpressPendiente($idconsultaExpress) {
        $consulta = $this->get($idconsultaExpress);
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta express", "result" => false]);
            return false;
        }
        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] != "1") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado pendiente", "result" => false]);
            return false;
        }

        if ($consulta["tomada"] != "0") {
            $this->setMsg(["msg" => "La consulta está siendo respondida por un profesional", "result" => false]);
            return false;
        }
        $this->db->StartTrans();
        $devolucion = $this->getManager("ManagerMovimientoCuenta")->processVencimientoCE(["idconsultaExpress" => $idconsultaExpress]);
        $republicar = $this->republicar_from_vencidas_paciente(["id" => $idconsultaExpress]);

        if ($devolucion && $republicar) {
            $this->db->CompleteTrans();
            $client = new XSocketClient();
            $client->emit("cambio_estado_consultaexpress_php", $consulta);
            $this->setMsg(["msg" => "Se ha cancelado la Consulta Express. El importe de la misma ha sido devuelto a su cuenta", "result" => true]);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo cancelar la consulta express", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente cuando se vence su consulta express
     * 
     * @param type $request
     */

    public function enviarMailVencimientoCE($idconsultaExpress) {

        //validamos la existencia del la consula express vencida
        $consulta = $this->get($idconsultaExpress);
        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] != "5") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra vencida", "result" => false
            ]);
            return false;
        }

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoConsultaExpress")->get($consulta["motivoConsultaExpress_idmotivoConsultaExpress"]);


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();



        $smarty->assign("paciente", $paciente);
        $smarty->assign("motivo", $motivo["motivoConsultaExpress"]);
        $smarty->assign("consulta", $consulta);



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare: Votre demande de Conseil Nº %s a expiré:", $consulta["numeroConsultaExpress"]));

        $mEmail->setBody($smarty->Fetch("email/mensaje_vencimiento_consultaexpress.tpl"));
        $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente cuando se vence su consulta express
     * 
     * @param type $request
     */

    public function enviarMailRechazoCE($idconsultaExpress) {

        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoRechazo")->get($consulta["motivoRechazo_idmotivoRechazo"])["motivoRechazo"];


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivoRechazo", $motivo);
        $smarty->assign("consulta", $consulta);



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare:  votre demande de conseil Nº %s a été déclinée ", $consulta["numeroConsultaExpress"]));
        $mEmail->setBody($smarty->Fetch("email/mensaje_rechazo_consultaexpress.tpl"));
        $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a medico si esta dirigida a profesional frecuente cuando se crea
     * 
     * @param type $request
     */

    public function enviarMailNuevaCE($idconsultaExpress) {

        //obtenemos la informacion de la CE
        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $mensaje = $this->getManager("ManagerMensajeConsultaExpress")->getPrimerMensaje($idconsultaExpress);
        $motivo = $this->getManager("ManagerMotivoConsultaExpress")->get($consulta["motivoConsultaExpress_idmotivoConsultaExpress"]);



        $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
        //Obtengo todas las imágenes del perfil de salud estudio
        $list_imagenes = $ManagerArchivosMensajeConsultaExpress->getListImages($mensaje["idmensajeConsultaExpress"]);

        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();

        //si la consulta esta dirigida a un profesional frecuente/favorito enviamos un mail directo
        if ($consulta["tipo_consulta"] == "1") {
            $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);


            if ($medico["email"] == "") {
                $this->setMsg(["msg" => "Error al recuperar email del medico ", "result" => false]);
                return false;
            }





            $smarty->assign("paciente", $paciente);
            $smarty->assign("medico", $medico);
            $smarty->assign("consulta", $consulta);
            $smarty->assign("motivo", $motivo["motivoConsultaExpress"]);
            $smarty->assign("mensaje", $mensaje["mensaje"]);
            $smarty->assign("imagenes", $list_imagenes);



            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);
            $mEmail->setBody($smarty->Fetch("email/mensaje_nueva_consultaexpress.tpl"));
            $mEmail->setSubject(sprintf("WorknCare: Nouvelle demande de Tchat Nº %s", $consulta["numeroConsultaExpress"]));

            $email = $medico["email"];
            $mEmail->addTo($email);
            //ojo solo arnet local
            $mEmail->setPort("587");



            if ($mEmail->send()) {
                $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
                return false;
            }
        } else {

            //Envio el mail a todos los medicos de la bolsa
            $ids_str = substr($consulta["ids_medicos_bolsa"], 1, strlen($consulta["ids_medicos_bolsa"]) - 2);
            $array_id_medico = explode(",", $ids_str);

            foreach ($array_id_medico as $id_medico) {
                $medico = $ManagerMedico->get($id_medico, true);

                $smarty->assign("paciente", $paciente);
                $smarty->assign("medico", $medico);
                $smarty->assign("consulta", $consulta);
                $smarty->assign("motivo", $motivo["motivoConsultaExpress"]);
                $smarty->assign("mensaje", $mensaje["mensaje"]);


                $mEmail = $this->getManager("ManagerMail");
                $mEmail->setHTML(true);
                $mEmail->setBody($smarty->Fetch("email/mensaje_nueva_consultaexpress_red.tpl"));
                $mEmail->setSubject(sprintf("WorknCare: Nouvelle demande de Tchat ", $consulta["numeroConsultaExpress"]));

                $email = $medico["email"];
                $mEmail->addTo($email);
                //ojo solo arnet local
                $mEmail->setPort("587");
                $status = true;
                if (!$mEmail->send()) {
                    $status = false;
                }
            }
            if ($status) {
                $this->setMsg(["msg" => "Mensajes enviados con éxito", "result" => true]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
                return false;
            }
        }
    }

    /**
     * Metodo que envia de un mail al medico cuando el paciente cancela la consulta
     * 
     * @param type $idconsultaExpress
     */
    public function enviarMailCancelacionConsulta($idconsultaExpress) {

        //obtenemos la informacion de la CE
        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $motivo = $this->getManager("ManagerMotivoConsultaExpress")->get($consulta["motivoConsultaExpress_idmotivoConsultaExpress"]);


        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();


        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);

        if ($medico["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del medico ", "result" => false]);
            return false;
        }



        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("consulta", $consulta);
        $smarty->assign("motivo", $motivo["motivoConsultaExpress"]);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_cancelar_consultaexpress.tpl"));
        $mEmail->setSubject(sprintf("WorknCare | Demande de Conseil Nº %s annulée", $consulta["numeroConsultaExpress"]));

        $email = $medico["email"];
        $mEmail->addTo($email);
        //ojo solo arnet local
        $mEmail->setPort("587");



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando vence la CE
     * @return boolean
     */
    public function enviarSMSVencimientoCE($idconsultaExpress) {
        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);


        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente["numeroCelular"];
            }
        }

        $cuerpo = "Votre Conseil Nº" . $consulta["numeroConsultaExpress"] . " a expiré : " .
                URL_ROOT . "patient/consultation-express/expirees-" . $consulta["idconsultaExpress"] . ".html";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Vencimiento CE",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando se rechaza la CE
     * @return boolean
     */
    public function enviarSMSRechazoCE($idconsultaExpress) {
        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);
        $motivo = $this->getManager("ManagerMotivoRechazo")->get($consulta["motivoRechazo_idmotivoRechazo"])["motivoRechazo"];
        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente["numeroCelular"];
            }
        }


        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a décliné votre Conseil Nº" . $consulta["numeroConsultaExpress"] .
                URL_ROOT . "patient/consultation-express/declinees.html";


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Rechazo CE",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);

            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando se finaliza la CE
     * @return boolean
     */
    public function enviarSMSFinalizacionCE($idconsultaExpress) {
        $consulta = $this->get($idconsultaExpress);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);
        $idperfilsaludconsulta = $this->getIdConclusion($idconsultaExpress);

        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                return false;
            } else {
                $numero = $paciente["numeroCelular"];
            }
        }

        if ($medico["sexo"] == "1") {
            $sexo = "Mr";
        } else {
            $sexo = "Mme";
        }

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a rédigé votre compte-rendu: " .
                URL_ROOT . "patient/profil-de-sante/consultations-realisees-detail/{$idperfilsaludconsulta}";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Finalización CE",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al medico SMS cuando le asignan una CE
     * @return boolean
     */
    public function enviarSMSNuevaCE($idconsultaExpress) {

        $consulta = $this->get($idconsultaExpress);

        $ManagerMedico = $this->getManager("ManagerMedico");
        if ($consulta["tipo_consulta"] == "1") {
            $medico = $ManagerMedico->get($consulta["medico_idmedico"]);
            if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
                $numero = $medico["numeroCelular"];
                $cuerpo = "Nouvelle demande par Tchat: "
                        . URL_ROOT . "professionnel/consultation-express/recues.html";
            } else {
                return false;
            }

            /**
             * Inserción del SMS en la lista de envio
             */
            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'M',
                "paciente_idpaciente" => $consulta["paciente_idpaciente"],
                "medico_idmedico" => $medico["idmedico"],
                "contexto" => "Nueva CE",
                "texto" => $cuerpo,
                "numero_cel" => $numero
            ]);


            if ($sms) {
                $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
                return true;
            } else {
                $this->setMsg($ManagerLogSMS->getMsg());

                return false;
            }
        } else {
            //Envio el sms a todos los medicos de la bolsa
            $ids_str = substr($consulta["ids_medicos_bolsa"], 1, strlen($consulta["ids_medicos_bolsa"]) - 2);
            $array_id_medico = explode(",", $ids_str);
            $status = true;
            foreach ($array_id_medico as $id_medico) {

                $medico = $ManagerMedico->get($id_medico);

                if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
                    $numero = $medico["numeroCelular"];
                    $cuerpo = "WorknCare | Nouvelle demande de Conseil publié sur la plateforme en lien avec votre spécialité: "
                            . URL_ROOT . "professionnel/consultation-express/publiees-sur-la-plateforme.html";

                    /**
                     * Inserción del SMS en la lista de envio
                     */
                    $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                    $sms = $ManagerLogSMS->insert([
                        "dirigido" => 'M',
                        //"paciente_idpaciente" => $paciente["idpaciente"],
                        "medico_idmedico" => $medico["idmedico"],
                        "contexto" => "Nueva CE",
                        "texto" => $cuerpo,
                        "numero_cel" => $numero
                    ]);


                    if (!$sms) {
                        $status = false;
                    }
                }
            }
            if ($status) {

                $this->setMsg(["msg" => "Mensajes enviados con éxito", "result" => true]);
                return true;
            } else {

                $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
                return false;
            }
        }
    }

    /**
     * Método que se utiliza para enviar al medico SMS cuando el paciente cancela la consulta
     * @return boolean
     */
    public function enviarSMSCancelacionConsulta($idconsultaExpress) {

        $consulta = $this->get($idconsultaExpress);

        $ManagerMedico = $this->getManager("ManagerMedico");

        $medico = $ManagerMedico->get($consulta["medico_idmedico"]);
        if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
            $numero = $medico["numeroCelular"];
            $cuerpo = "Demande par Tchat annulée";
        } else {
            return false;
        }

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'M',
            "paciente_idpaciente" => $consulta["paciente_idpaciente"],
            "medico_idmedico" => $medico["idmedico"],
            "contexto" => "Cancelar CE",
            "texto" => $cuerpo,
            "numero_cel" => $numero
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /*     * Metodo que retorna el id del perfil de salud consulta correspondiene al cierre de la consultaexpress con las conclusiones por parte del medico
     * 
     * @param type $idconsultaexpress
     */

    public function getIdConclusion($idconsultaexpress) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("perfilsaludconsulta psc");
        $query->setWhere("psc.consultaExpress_idconsultaExpress=$idconsultaexpress and psc.is_cerrado=1");

        $rdo = $this->db->getRow($query->getSql());
        return $rdo["idperfilSaludConsulta"];
    }

    /*     * Metodo mediante el cual un prestador crea una consulta express en nombre de un paciente hacia un medico
     * La CE se le publica como pendiente al medico y este continua el flujo normal 
     */

    public function crearConsultaExpressFromPrestador($request) {

        $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        if ($request["paciente_idpaciente"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el paciente de la Consulta Express"]);
            return false;
        }
        if ($request["medico_idmedico"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el médico de la Consulta Express"]);
            return false;
        }
        if ($request["motivoConsultaExpress_idmotivoConsultaExpress"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el motivo de la Consulta Express"]);
            return false;
        }

        if ($request["mensaje"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Ingrese un detalle de la Consulta Express"]);
            return false;
        }
        $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
        if ($prestador["valorConsultaExpress"] == "" && $prestador["descuento"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No tiene configurado el valor de la Consulta Express"]);
            return false;
        }
        $this->db->StartTrans();
        //borramos las CE previas que pueda tener el paciente

        $delete_borrador = $this->deleteBorrador($request["paciente_idpaciente"]);

        if (!$delete_borrador) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
            return false;
        }

        $request["estadoConsultaExpress_idestadoConsultaExpress"] = 1;
        $request["consulta_step"] = 0;
        $request["tipo_consulta"] = 1;
        $request["precio_tarifa"] = 0;
        //guardamos el precio de la CE que establece el prestador
        //si el prestador ofrece un descuento, calculamos la tarifa sobre lo que cobra el medico y hacemos el descuento
        if ($prestador["descuento"] != "") {
            $preferencia_medico = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($request["medico_idmedico"]);
            if ($preferencia_medico["valorPinesConsultaExpress"] == "") {

                $this->setMsg(["result" => false, "msg" => "Error. El profesional no tiene configurado el valor de la consulta express para aplicar descuento"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $precio_tarifa_prestador = $preferencia_medico["valorPinesConsultaExpress"] - ($preferencia_medico["valorPinesConsultaExpress"] * (int) $prestador["descuento"] / 100);
        } else {
            $precio_tarifa_prestador = $prestador["valorConsultaExpress"];
        }
        $request["precio_tarifa_prestador"] = $precio_tarifa_prestador;
        $request["comision_prestador"] = 0;
        $request["from_prestador"] = 1;
        //Fechas de inicio
        $request["fecha_inicio"] = $request["fecha_ultimo_mensaje"] = date("Y-m-d H:i:s");

        //Fecha vencimiento:Duracion de Profesionales frecuentes
        $request["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_CE_FRECUENTES . " hour", strtotime($request["fecha_inicio"]));

        $rdo = $this->insert($request);
        if (!$rdo) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Consulta Express"]);
            return false;
        }
        $request["idconsultaExpress"] = $rdo;
        $record["consultaExpress_idconsultaExpress"] = $rdo;
        $record["mensaje"] = $request["mensaje"];
        $record["emisor"] = "p";
        $record["fecha"] = date("Y-m-d H:i:s");

        $msj = $this->getManager("ManagerMensajeConsultaExpress")->basic_insert($record);
        if (!$msj) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo ingresar el mensaje la Consulta Express"]);
            return false;
        }
        //generamos el movimiento al paciente 
        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");

        $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionCE($request);
        if (!$movimiento_cuenta) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg($ManagerMovimientoCuenta->getMsg());
            return false;
        }

        //notificamos al Medico 
        $this->enviarSMSNuevaCE($rdo);
        //enviamos el mail al/los medicos asociados 
        $this->enviarMailNuevaCE($request["idconsultaExpress"]);


        //evento de cambio de estado

        $consulta = parent::get($rdo);



        $this->db->CompleteTrans();
        $client = new XSocketClient();
        $client->emit('cambio_estado_consultaexpress_php', $consulta);

        //notify
        $paciente = $this->getManager("ManagerPaciente")->get($request["paciente_idpaciente"]);
        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
        $notify["text"] = "Nouvelle demande par Tchat";
        $notify["medico_idmedico"] = $request["medico_idmedico"];
        $notify["style"] = "consulta-express";
        $client->emit('notify_php', $notify);

        $this->setMsg(["result" => true, "msg" => "Consulta Express publicada con éxito"]);
        return true;
    }

    /**
     * Metodo que obtiene datos para el dashboard de las consultas express  
     */
    public function getDatosGraficoConsultasExpress() {

// para estadoConsultaExpress_idestadoConsultaExpress=5
        $query = new AbstractSql();
        $query->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query->setFrom("$this->table c INNER JOIN estadoconsultaexpress e on (e.idestadoConsultaExpress=c.estadoConsultaExpress_idestadoConsultaExpress)");
        $query->setWhere("c.fecha_inicio is not null");
        $query->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query->addAnd("c.estadoConsultaExpress_idestadoConsultaExpress=5");
        $query->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");


        $listado = $this->getList($query);


        // para estadoConsultaExpress_idestadoConsultaExpress=4      
        $query4 = new AbstractSql();
        $query4->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query4->setFrom("$this->table c INNER JOIN estadoconsultaexpress e on (e.idestadoConsultaExpress=c.estadoConsultaExpress_idestadoConsultaExpress)");
        $query4->setWhere("c.fecha_inicio is not null");
        $query4->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query4->addAnd("c.estadoConsultaExpress_idestadoConsultaExpress=4");
        $query4->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");


        $listado4 = $this->getList($query4);

        // para estadoConsultaExpress_idestadoConsultaExpress=3     
        $query3 = new AbstractSql();
        $query3->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query3->setFrom("$this->table c INNER JOIN estadoconsultaexpress e on (e.idestadoConsultaExpress=c.estadoConsultaExpress_idestadoConsultaExpress)");
        $query3->setWhere("c.fecha_inicio is not null");
        $query3->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query3->addAnd("c.estadoConsultaExpress_idestadoConsultaExpress=3");
        $query3->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");


        $listado3 = $this->getList($query3);

        $this->setMsg(["lista5" => $listado, "lista4" => $listado4, "lista3" => $listado3]);
    }

}

//END_class
?>