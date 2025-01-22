<?php

/**
 * 	Manager de videoconsulta
 *
 * 	@author lucas
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerVideoConsulta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "videoconsulta", "idvideoconsulta");
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

        //se obtienen los datos del emisor se sesion,  y el destinatario por request
        // Fixeo esto para hacerlo genérico para ser llamado en forma manual por URL indicando sobre que paciente y sobre que médico quiero crear la videoconsulta.
        /* if (CONTROLLER == "paciente_p") {
          $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
          $request["paciente_idpaciente"] = $paciente["idpaciente"];
          if ($request["medico_idmedico"] == "") {
          $this->setMsg(["msg" => "Ingrese el medico", "result" => true]);
          }
          }
          if (CONTROLLER == "medico") {
          $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
          $request["medico_idmedico"] = $idmedico;
          if ($request["paciente_idpaciente"] == "") {
          $this->setMsg(["msg" => "Ingrese el paciente", "result" => true]);
          }
          } */
//obtenemos la fecha del sistema
        // $request["fecha_inicio"] = date("Y-m-d H:i:s");
        //creo el registro
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
            $request["prestador_idprestador"] = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"];
        }
        $id = parent::insert($request);
        //creamos el numero de consulta express formateado
        $record["numeroVideoConsulta"] = STR_PAD($id, 7, "0", STR_PAD_LEFT);

        $rdo = parent::update($record, $id);

        if ($id && $rdo) {
            $this->setMsg(["msg" => "Se ha creado la videoconsulta con éxito", "result" => true, "id" => $id]);
            return $id;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo crear la Video Consulta", "result" => false]);
            return false;
        }
    }

    /*     * Inserta un registro en la tabla correspondiente
     * 
     * @param type $request
     */

    public function basic_insert($request) {
        return parent::insert($request);
    }

    /*     * actualiza un registro en la tabla correspondiente
     * 
     * @param type $request
     */

    public function basic_update($request, $id) {
        return parent::update($request, $id);
    }

    /**
     * 	Realiza Update de un registro
     *
     * 	@author UTN
     * 	@version 1.0
     *
     * 	@param mixed $request Arreglo que contiene todos los campos para su actualizacion
     * 	@param int $id clave primaria del registro a actualizar.
     * 	@return int|booelan Retorna el id del registro actualizado o falso dependiendo de que se haya realizado correctamente el UPDATE
     */
    public function update($request, $id) {

        //Guardo el registro
        $result = parent::update($request, $id);

        //si se crea correctamente asocio las funcionaldades y si aplica o no

        if ($result) {

            $this->setMsg(["msg" => "registro actualizado con éxito", "result" => true]);
        }

        return $result;
    }

    /*     * Metodo que obtiene el registro correspondiente a una videoconsulta
     * 
     * @param type $idvideoconsulta
     * @return type
     * @throws ExceptionErrorPage
     */

    public function get($idvideoconsulta) {

        $videoconsulta = parent::get($idvideoconsulta);

        //verificamos que la consulta perenezca al paciente o medico conectado
        if (CONTROLLER == "paciente_p") {
            $idpaciente_session = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($videoconsulta["paciente_idpaciente"], $idpaciente_session);

            //verificamos que la consulta sea del titular o algun miembro

            if ($videoconsulta["paciente_idpaciente"] != $paciente["idpaciente"] && $videoconsulta["paciente_idpaciente"] != $idpaciente_session && $familiar["pacienteGrupo"] != $videoconsulta["paciente_idpaciente"]) {

                //throw new ExceptionErrorPage("No se pudo recuperar la videoconsulta");
                //redirigir  a la home
                header('Location:' . URL_ROOT . "panel-paciente/videoconsulta/");
                exit;
            }
        }

        if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ($videoconsulta["medico_idmedico"] != $idmedico && $videoconsulta["tipo_consulta"] != 0) {

                //throw new ExceptionErrorPage("No se pudo recuperar la videoconsulta");
                //redirigir  a la home
                header('Location:' . URL_ROOT . "panel-medico/videoconsulta/");
                exit;
            }
        }
        return $videoconsulta;
    }

    /*     * Metodo que obtiene la ultima video consulta del paciente que quedo en estado borrador
     * 
     * @param type $idpaciente
     */

    public function getVideoConsultaBorrador($idpaciente) {

        return $this->db->getRow("select * from $this->table where paciente_idpaciente=$idpaciente and estadoVideoConsulta_idestadoVideoConsulta=6");
    }

    /*     * Metodo que elimina las video consultas que quedan en estado borrador
     * 
     * @param type $idpaciente
     */

    public function deleteBorrador($idpaciente) {

        $rdo = $this->db->Execute("delete from $this->table where estadoVideoConsulta_idestadoVideoConsulta=6 and paciente_idpaciente=$idpaciente");
        return $rdo;
    }

    /*     * Metodo que retorocede a un paso especifico una video consulta, realizando las eliminaciones y cambios requeridos 
     * de los campos ingresados en los pasos posteriores al seleccionado
     * 
     */

    public function back_step($request) {

        $consulta = parent::get($request["idvideoconsulta"]);
        if ($request["idvideoconsulta"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);
            return false;
        }






        //verificamos que pertenezca al paciente
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta", "result" => false]);
            return false;
        }
        if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "6") {
            $this->setMsg(["msg" => "Error. La video consulta no se encuentra en estado borrador", "result" => false]);
            return false;
        }

        switch ((int) $request["step"]) {
            case 1:
                //verificamos que sea un step correcto
                if ($consulta["consulta_step"] == "2" || $consulta["consulta_step"] == "3" || $consulta["consulta_step"] == "4") {
                    $rdo1 = $result = $this->delete($request["idvideoconsulta"], true);
                    $rdo2 = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->deleteFiltrosBusqueda($request["idvideoconsulta"]);
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

                    $rdo1 = $this->update($request, $request["idvideoconsulta"]);
                    $rdo2 = true;
                    break;
                } else {
                    $step_invalido = true;
                }
            case 3:
                if ($consulta["consulta_step"] == "3" || $consulta["consulta_step"] == "4") {
                    $request["consulta_step"] = 3;
                    $rdo1 = $this->update($request, $request["idvideoconsulta"]);
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

    /**
     * Metodo encargado de anular los turnos de VC pendientes que no fueron respondidos luego de 6 dias
     */
    public function actualizarVencimientoTurnosVCPendientes() {

        if (CONTROLLER == "common") {
            $query = new AbstractSql();
            $query->setSelect("idturno");
            $query->setFrom("turno");
            $query->setWhere("estado=0 and paciente_idpaciente is not null and SYSDATE()> DATE_ADD(fechaSolicitudTurno,INTERVAL 6 DAY)");
            $turnos_pendientes = $this->getList($query);
            $ManagerTurno = $this->getManager("ManagerTurno");
            foreach ($turnos_pendientes as $turno) {
                $record["idturno"] = $turno["idturno"];
                //$record["mensaje"] = "Le professionnel n'a pas répondu à votre demande de Vidéo Consultation sur rendez-vous. La demande a été automatiquement annulée et l'argent remboursé sur votre compte.";
                $record["idmedico"] = $turno["medico_idmedico"];
                $ManagerTurno->cancelarTurnoFromCron($record);
            }
        }
    }

    /*
     * Metodo que cambia automaticamente el estados de las videoconsultas a vencidas luego de un tiempo desde la crecacion
     * 
     * @param type $request
     */

    public function actualizarEstados() {

        //Actualizamos las videoconsultas que se han iniciado y termino el tiempo de videoconsulta sin ser finalizadas
        $this->actualizarEstadoConsultasTerminadas();
        //Si transcurre el tiempo de espera en la sala cuando el medico llama nuevamente al paciente la consulta vuelve a estado pendiente de finalizacion
        $this->actualizarEstadoConsultasPendientesFinalizacion();
        //enviamos recordatorio 5 min antes de la VC
        $this->recordatorioProximaVC();


        //actualizamos las videoconsultas vencidas cuando el paciente ingresa a la bandeja de entrada

        if (CONTROLLER == "paciente_p") {

            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            if ($paciente["idpaciente"] == "") {
                $idpaciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
            } else {
                $idpaciente = $paciente["idpaciente"];
            }

            //obtenemos las videoconsultas del paciente en sesion o familiares y que ha pasado el tiempo de publicacion
            $query1 = new AbstractSql();
            $query1->setSelect("*");
            $query1->setFrom("(select vc.*,IFNULL(pgf.pacienteTitular,vc.paciente_idpaciente)as idpaciente from "
                    . "$this->table vc LEFT JOIN pacientegrupofamiliar pgf on (vc.paciente_idpaciente=pgf.pacienteGrupo))as T");

            $query1->setWhere("T.estadoVideoConsulta_idestadoVideoConsulta=1 and T.tomada=0 and T.tipo_consulta<>2 and
                T.paciente_idpaciente=$idpaciente and SYSDATE()> T.fecha_vencimiento");
            $listado1 = $this->getList($query1);

            //obtenemos las videoconsultas del paciente en sesion o familiares que estan abiertas y no se han iniciado
            $query2 = new AbstractSql();
            $query2->setSelect("*");
            $query2->setFrom("(select vc.*,IFNULL(pgf.pacienteTitular,vc.paciente_idpaciente)as idpaciente from "
                    . "$this->table vc LEFT JOIN pacientegrupofamiliar pgf on (vc.paciente_idpaciente=pgf.pacienteGrupo))as T");
            $query2->setWhere("T.estadoVideoConsulta_idestadoVideoConsulta=2 and T.medico_idmedico IS NOT NULL and inicio_llamada is NULL and reapertura_sala=0  and
                T.paciente_idpaciente=$idpaciente and SYSDATE()> DATE_ADD(T.inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)");
            $listado2 = $this->getList($query2);




            $listado = array_merge($listado1, $listado2);
            if (count($listado) > 0) {



                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $VC) {

                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $videoconsulta = $this->get($VC["idvideoconsulta"]);
                    if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    $res = $ManagerMovimientoCuenta->processVencimientoVC(["idvideoconsulta" => $VC["idvideoconsulta"]]);
                    //actualizamos el estado de la consulta
                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 5;
                    $rdo = parent::update($record, $VC["idvideoconsulta"]);
                    //devolvemos el dinero a los pacientes

                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                        //notify
                        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Vidéo Consultation expirée";
                        $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                        $notify["style"] = "video-consulta";
                        $notify["type"] = "vencimiento-vc";
                        $notify["id"] = $videoconsulta["idvideoconsulta"];
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoVC($VC["idvideoconsulta"]);
                        $this->enviarSMSVencimientoVC($VC["idvideoconsulta"]);
                    }
                }
            }

            //actualizamos las videoconsultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("(select vc.*,IFNULL(pgf.pacienteTitular,vc.paciente_idpaciente)as idpaciente from "
                    . "$this->table vc LEFT JOIN pacientegrupofamiliar pgf on (vc.paciente_idpaciente=pgf.pacienteGrupo))as T");
            $queryTomadas->setWhere("(T.estadoVideoConsulta_idestadoVideoConsulta=1 OR T.estadoVideoConsulta_idestadoVideoConsulta=2) and T.tipo_consulta=0 and T.tomada=1 and 
                T.paciente_idpaciente={$idpaciente}  and SYSDATE()> T.fecha_vencimiento_toma and inicio_sala is null");

            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {
                //limpiamos los datos del medico que tomo la VC
                foreach ($tomadas as $VC) {
                    $this->db->StartTrans();
                    //actualizamos el tiempo que le queda
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["aceptar_en"] = "";
                    $record["precio_tarifa"] = "";
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 1;
                    $record["notificacion_ingreso_sala"] = 0;
                    $record["inicio_sala"] = "";
                    $record["inicio_llamada"] = "";

                    //aumentamos el tiempo de vencimiento segun el tiempo que estuvo tomada por el medico
                    /* $vencimiento = date_create($VC["fecha_vencimiento"]);
                      $fecha_toma = date_create($VC["fecha_toma"]);
                      $intervalo = date_diff($vencimiento, $fecha_toma);

                      $add_mins = $intervalo->format('%i');
                      $add_sec = $intervalo->format('%s');

                      $record["fecha_vencimiento"] = strtotime('+' . $add_mins . 'minutes ' . $add_sec . ' seconds', strtotime(date("Y-m-d H:i:s")));
                     */
                    $rdo1 = parent::update($record, $VC["idvideoconsulta"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }
                    $this->db->CompleteTrans();
                }
            }

            //vencemos las consultas solicitadas por turno medico abiertas que no se han iniciado
            /* $this->db->StartTrans();
              $rdo = $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=5 where estadoVideoConsulta_idestadoVideoConsulta=2 and
              tipo_consulta=2 and paciente_idpaciente=$idpaciente  and SYSDATE()> fecha_vencimiento");

              if (!$rdo) {
              $this->db->FailTrans();
              $this->db->CompleteTrans();
              } else {
              $this->db->CompleteTrans();
              }
             */


            return;
        }
        //actualizamos las videoconsultas vencidas cuando el medico ingresa a la bandeja de entrada
        if (CONTROLLER == "medico") {

            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            //obtenemos las conultas realiadas al medico  y que ha pasado el tiempo de publicacion
            $query1 = new AbstractSql();
            $query1->setSelect("idvideoconsulta");
            $query1->setFrom("$this->table");
            $query1->setWhere("estadoVideoConsulta_idestadoVideoConsulta=1 and tomada=0  and medico_idmedico=$idmedico            
                    and SYSDATE()>fecha_vencimiento ");
            $listado1 = $this->getList($query1);


            //obtenemos las videoconsultas del paciente en sesion o familiares que estan abiertas y no se han iniciado
            $query2 = new AbstractSql();
            $query2->setSelect("idvideoconsulta");
            $query2->setFrom("$this->table vc");
            $query2->setWhere("estadoVideoConsulta_idestadoVideoConsulta=2 and inicio_llamada is NULL and reapertura_sala=0  and
                medico_idmedico=$idmedico and SYSDATE()> DATE_ADD(vc.inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)");
            $listado2 = $this->getList($query2);



            $listado = array_merge($listado1, $listado2);


            if (count($listado) > 0) {

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $VC) {
                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $videoconsulta = $this->get($VC["idvideoconsulta"]);
                    if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    //devolvemos el dinero a los pacientes y enviamos un mail

                    $res = $ManagerMovimientoCuenta->processVencimientoVC(["idvideoconsulta" => $VC["idvideoconsulta"]]);

                    //actualizamos el estado de la consulta
                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 5;
                    $rdo = parent::update($record, $VC["idvideoconsulta"]);


                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);
                        //notify
                        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Vidéo Consultation expirée";
                        $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                        $notify["style"] = "video-consulta";
                        $notify["type"] = "vencimiento-vc";
                        $notify["id"] = $videoconsulta["idvideoconsulta"];
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoVC($VC["idvideoconsulta"]);
                        $this->enviarSMSVencimientoVC($VC["idvideoconsulta"]);
                    }
                }
            }


            //actualizamos las videoconsultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("$this->table");
            $queryTomadas->setWhere("(estadoVideoConsulta_idestadoVideoConsulta=1 OR estadoVideoConsulta_idestadoVideoConsulta=2) and  tipo_consulta=0 and tomada=1 and
              SYSDATE()> fecha_vencimiento_toma and inicio_sala is null");
            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {

                foreach ($tomadas as $VC) {
                    $this->db->StartTrans();
                    //limpiamos los datos del medico que tomo la VC
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["aceptar_en"] = "";
                    $record["precio_tarifa"] = "";
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 1;
                    $record["notificacion_ingreso_sala"] = 0;
                    $record["inicio_sala"] = "";
                    $record["inicio_llamada"] = "";

                    //aumentamos el tiempo de vencimiento segun el tiempo que estuvo tomada por el medico
                    /* $vencimiento = date_create($VC["fecha_vencimiento"]);
                      $fecha_toma = date_create($VC["fecha_toma"]);
                      $intervalo = date_diff($vencimiento, $fecha_toma);

                      $add_mins = $intervalo->format('%i');
                      $add_sec = $intervalo->format('%s');

                      //$record["fecha_vencimiento"] = strtotime('+' . $add_mins . 'minutes ' . $add_sec . ' seconds', strtotime(date("Y-m-d H:i:s")));
                     */
                    $rdo1 = parent::update($record, $VC["idvideoconsulta"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }
                    $this->db->CompleteTrans();
                }
            }

            //vencemos las consultas solicitadas por turno medico abiertas que no se han iniciado
            /*  $this->db->StartTrans();
              $rdo = $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=5 where estadoVideoConsulta_idestadoVideoConsulta=2 and
              tipo_consulta=2 and medico_idmedico=$idmedico  and SYSDATE()> fecha_vencimiento");
              if (!$rdo) {
              $this->db->FailTrans();
              $this->db->CompleteTrans();
              } else {
              $this->db->CompleteTrans();
              } */

            return;
        }

        //cron que actualiza las videoconsultas vencidas 
        if (CONTROLLER == "common") {

            //obtenemos las videoconsultas realizadas  y que ha pasado el tiempo de publicacion
            $query1 = new AbstractSql();
            $query1->setSelect("idvideoconsulta");
            $query1->setFrom("$this->table");
            $query1->setWhere("estadoVideoConsulta_idestadoVideoConsulta=1 and tomada=0 and tipo_consulta<>2
                and SYSDATE()> fecha_vencimiento");
            $listado1 = $this->getList($query1);

            //obtenemos las videoconsultas que no se han iniciado
            $query2 = new AbstractSql();
            $query2->setSelect("idvideoconsulta");
            $query2->setFrom("$this->table vc");
            $query2->setWhere("estadoVideoConsulta_idestadoVideoConsulta=2 and medico_idmedico IS NOT NULL and inicio_llamada is NULL and reapertura_sala=0  and 
                SYSDATE()> DATE_ADD(vc.inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)");
            $listado2 = $this->getList($query2);


            $listado = array_merge($listado1, $listado2);



            if (count($listado) > 0) {



                //devolvemos el dinero a los pacientes

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $ManagerPaciente = $this->getManager("ManagerPaciente");
                foreach ($listado as $VC) {
                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $videoconsulta = $this->get($VC["idvideoconsulta"]);
                    if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 5) {
                        break;
                    }
                    $this->db->StartTrans();
                    //devolvemos el dinero a los pacientes y enviamos un mail
                    $res = $ManagerMovimientoCuenta->processVencimientoVC(["idvideoconsulta" => $VC["idvideoconsulta"]]);

                    $record["leido_medico"] = 0;
                    $record["leido_paciente"] = 0;
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 5;
                    $rdo = parent::update($record, $VC["idvideoconsulta"]);
                    if (!$res || !$rdo) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    } else {
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                        //notify
                        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Vidéo Consultation expirée";
                        $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                        $notify["style"] = "video-consulta";
                        $notify["type"] = "vencimiento-vc";
                        $notify["id"] = $videoconsulta["idvideoconsulta"];
                        $client->emit('notify_php', $notify);

                        $this->enviarMailVencimientoVC($VC["idvideoconsulta"]);
                        $this->enviarSMSVencimientoVC($VC["idvideoconsulta"]);
                    }
                }
            }

            //actualizamos las videoconsultas tomadas cuando vence su tiempo y vuelven a la bolsa
            $queryTomadas = new AbstractSql();
            $queryTomadas->setSelect("*");
            $queryTomadas->setFrom("$this->table");
            $queryTomadas->setWhere("(estadoVideoConsulta_idestadoVideoConsulta=1 OR estadoVideoConsulta_idestadoVideoConsulta=2) and tipo_consulta=0 and tomada=1 and 
                 SYSDATE()> fecha_vencimiento_toma and inicio_sala is null");

            $tomadas = $this->getList($queryTomadas);

            if (count($tomadas) > 0) {
                //limpiamos los datos del medico que tomo la VC
                foreach ($tomadas as $VC) {
                    $this->db->StartTrans();
                    //actualizamos el tiempo que le queda
                    $record["fecha_vencimiento_toma"] = "";
                    $record["fecha_toma"] = "";
                    $record["medico_idmedico"] = "";
                    $record["tomada"] = 0;
                    $record["aceptar_en"] = "";
                    $record["precio_tarifa"] = "";
                    $record["estadoVideoConsulta_idestadoVideoConsulta"] = 1;
                    $record["notificacion_ingreso_sala"] = 0;
                    $record["inicio_sala"] = "";
                    $record["inicio_llamada"] = "";



                    //aumentamos el tiempo de vencimiento segun el tiempo que estuvo tomada por el medico
                    /* $vencimiento = date_create($VC["fecha_vencimiento"]);
                      $fecha_toma = date_create($VC["fecha_toma"]);
                      $intervalo = date_diff($vencimiento, $fecha_toma);

                      $add_mins = $intervalo->format('%i');
                      $add_sec = $intervalo->format('%s');

                      $record["fecha_vencimiento"] = strtotime('+' . $add_mins . 'minutes ' . $add_sec . ' seconds', strtotime(date("Y-m-d H:i:s")));
                     */
                    $rdo1 = parent::update($record, $VC["idvideoconsulta"]);

                    if (!$rdo1) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return;
                    }
                    $this->db->CompleteTrans();
                }
            }


            //marcar habilitar el consultorio en la bandeja de entrada cuando se ha iniciado la sala

            $queryHabilitarConsultorio = new AbstractSql();
            $queryHabilitarConsultorio->setSelect("*");
            $queryHabilitarConsultorio->setFrom("$this->table");
            $queryHabilitarConsultorio->setWhere("(estadoVideoConsulta_idestadoVideoConsulta=7 OR (estadoVideoConsulta_idestadoVideoConsulta=2 and SYSDATE()>=inicio_sala))  ");
            $HabilitarConsultorio = $this->getList($queryHabilitarConsultorio);

            if (count($HabilitarConsultorio) > 0) {
                foreach ($HabilitarConsultorio as $VC) {
                    //obtenemos la consulta para verificar que no haya sido vencida por el cron, medico, o paciente concurrentemente
                    $videoconsulta = $this->get($VC["idvideoconsulta"]);


                    $client = new XSocketClient();
                    $client->emit("habilitar_consultorio_virtual_php", $videoconsulta);
                }
            }


            //vencemos las consultas solicitadas por turno medico abiertas que no se han iniciado
            /* $this->db->StartTrans();
              $rdo = $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=5 where estadoVideoConsulta_idestadoVideoConsulta=2 and
              tipo_consulta=2 and  SYSDATE()> fecha_vencimiento");

              if (!$rdo) {
              $this->db->FailTrans();
              $this->db->CompleteTrans();
              } else {
              $this->db->CompleteTrans();
              } */

            return;
        }
    }

    /*     * Metodo que actualiza las videoconsultas que se han iniciado y termino el tiempo de videoconsulta sin ser finalizadas
     * 
     */

    public function actualizarEstadoConsultasTerminadas() {
        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8 where estadoVideoConsulta_idestadoVideoConsulta=7  and paciente_idpaciente={$paciente["idpaciente"]} and SYSDATE() > fin_llamada");
        } else if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8 where estadoVideoConsulta_idestadoVideoConsulta=7  and medico_idmedico={$idmedico} and SYSDATE() > fin_llamada");
        } else {
            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8 where estadoVideoConsulta_idestadoVideoConsulta=7  and SYSDATE() > fin_llamada");
        }
    }

    /*     * Metodo que actualiza las videoconsultas que estan pendientes de finalizacion y el medico ha vuelto a iniciar la videoconsulta 
     * esperando el paciente. Si transcurre el tiempo de espera en la sala la consulta vuelve a estado pendiente de finalizacion
     * 
     */

    public function actualizarEstadoConsultasPendientesFinalizacion() {

//actualizamos el estado de las consultas pendientes de finalizacion que aun no han pasado las 6 horas de su publicacion, si el paciente no ingresa a la sala vuelven a estar pendientes de finalizacion

        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8, inicio_sala=NULL, inicio_llamada=NULL where estadoVideoConsulta_idestadoVideoConsulta=2  and reapertura_sala=1 and SYSDATE() > DATE_ADD(inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)
                and paciente_idpaciente={$paciente["idpaciente"]} and SYSDATE() < DATE_ADD(fecha_inicio,INTERVAL " . VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION . " HOUR)");
        } else if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8, inicio_sala=NULL, inicio_llamada=NULL where estadoVideoConsulta_idestadoVideoConsulta=2  and reapertura_sala=1 and SYSDATE() > DATE_ADD(inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)
                and medico_idmedico={$idmedico} and SYSDATE() < DATE_ADD(fecha_inicio,INTERVAL " . VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION . " HOUR)");
        } else {
            $this->db->Execute("update $this->table set estadoVideoConsulta_idestadoVideoConsulta=8, inicio_sala=NULL, inicio_llamada=NULL where estadoVideoConsulta_idestadoVideoConsulta=2  and reapertura_sala=1 and SYSDATE() > DATE_ADD(inicio_sala,INTERVAL " . VIDEOCONSULTA_VENCIMIENTO_SALA . " MINUTE)
                and  SYSDATE() < DATE_ADD(fecha_inicio,INTERVAL " . VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION . " HOUR)");
        }

        //obtenemos el listado de las consultas pendientes de finalizacion que han pasado 6 hora de su publicacion, para acreditar el dinero si el medico intento llamar o  sino devolverlo al paciente
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table t");
        $query->setWhere("estadoVideoConsulta_idestadoVideoConsulta=8 and SYSDATE() >= DATE_ADD(fin_llamada,INTERVAL " . VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION . " HOUR)");
        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $query->addAnd("paciente_idpaciente={$paciente["idpaciente"]}");
        }
        if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $query->addAnd("medico_idmedico={$idmedico}");
        }
        $listado = $this->getList($query);

        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        foreach ($listado as $videoconsulta) {

            //si el medico no intento llamar al paciente le devolvemos el dinero
            if ($videoconsulta["reapertura_sala"] == "0") {

                if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 5) {
                    break;
                }
                $this->db->StartTrans();
                //devolvemos el dinero a los pacientes y vencemos la Video Consulta
                $res = $ManagerMovimientoCuenta->processVencimientoVC(["idvideoconsulta" => $videoconsulta["idvideoconsulta"]]);
                //actualizamos el estado de la consulta
                $record["leido_medico"] = 2;
                $record["leido_paciente"] = 2;
                $record["estadoVideoConsulta_idestadoVideoConsulta"] = 5;
                $rdo = parent::update($record, $videoconsulta["idvideoconsulta"]);


                if (!$res || !$rdo) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                } else {
                    $this->db->CompleteTrans();
                    $this->enviarMailVencimientoVC($videoconsulta["idvideoconsulta"]);
                    $this->enviarSMSVencimientoVC($videoconsulta["idvideoconsulta"]);
                }
            } else {//si el medico si intento llamar al paciente pero no se inicio la videoconsulta le acreditamos el dinero al medico
                //actualizamos el estado de la consulta
                $this->db->StartTrans();

                $record["leido_medico"] = 0;
                $record["leido_paciente"] = 0;
                $record["estadoVideoConsulta_idestadoVideoConsulta"] = 4;
                $rdo = parent::update($record, $videoconsulta["idvideoconsulta"]);
                //acreditamos el dinero al medico
                $acreditar_medico = $this->getManager("ManagerMovimientoCuenta")->processFinalizacionVC(["idvideoconsulta" => $videoconsulta["idvideoconsulta"], "medico_idmedico" => $videoconsulta["medico_idmedico"]]);
                if (!$rdo || !$acreditar_medico) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                } else {
                    $this->db->CompleteTrans();
                }
            }
        }
    }

    /**
     * Método que envia una notificacion emergente x websockets al médico cuando tiene un VC a 5 min de empezar
     *   
     */
    public function recordatorioProximaVC() {
        if (CONTROLLER == "common") {
            //obtenemos el listado de las consultas pendientes que inician en 5 min
            $query = new AbstractSql();
            $query->setSelect("idvideoconsulta,medico_idmedico,paciente_idpaciente, IFNULL(u.nombre,pf.nombre) as paciente_nombre, IFNULL(u.apellido,pf.apellido) as paciente_apellido,um.nombre AS medico_nombre,um.apellido AS medico_apellido ");

            $query->setFrom("videoconsulta v
	INNER JOIN paciente p ON ( p.idpaciente = v.paciente_idpaciente )
	INNER JOIN medico m ON ( m.idmedico = v.medico_idmedico )
	LEFT JOIN usuarioweb u ON ( p.usuarioweb_idusuarioweb = u.idusuarioweb AND u.registrado = 1 )
	LEFT JOIN pacientegrupofamiliar pf ON ( p.idpaciente = pf.pacienteGrupo )
	LEFT JOIN usuarioweb um ON ( m.usuarioweb_idusuarioweb = um.idusuarioweb AND um.registrado = 1 ) ");

            $query->setWhere("estadoVideoConsulta_idestadoVideoConsulta = 2 AND recordatorio_inicio_sala IS NULL AND inicio_sala >= SYSDATE() AND inicio_sala < DATE_ADD( SYSDATE(), INTERVAL 5 MINUTE )");

            $listado = $this->getList($query);

            foreach ($listado as $videoconsulta) {

                $this->db->StartTrans();

                //actualizamos el estado de la consulta
                $record["recordatorio_inicio_sala"] = 1;
                $rdo = parent::update($record, $videoconsulta["idvideoconsulta"]);
                $this->enviarSMSPacienteProximaVC($videoconsulta["idvideoconsulta"]);
                $this->enviarSMSMedicoProximaVC($videoconsulta["idvideoconsulta"]);
                $this->enviarMailPacienteProximaVC($videoconsulta["idvideoconsulta"]);
                $this->enviarMailMedicoProximaVC($videoconsulta["idvideoconsulta"]);
                if (!$rdo) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                }
                $this->db->CompleteTrans();
                //notify
                $client = new XSocketClient();
                //enviamos notificacion al medico asociado 

                $notifyMedico["title"] = "{$videoconsulta["paciente_nombre"]} {$videoconsulta["paciente_apellido"]} - Vidéo Consultation";
                $notifyMedico["text"] = "Votre prochaine Vidéo Consultation commence dans moins de 5 minutes";
                $notifyMedico["type"] = "recordatorio-proxima-vc";
                $notifyMedico["id"] = $videoconsulta["idvideoconsulta"];
                $notifyMedico["medico_idmedico"] = $videoconsulta["medico_idmedico"];
                $notifyMedico["style"] = "video-consulta";
                $client->emit('notify_php', $notifyMedico);

                //enviamos notificacion al paciente asociado 
                $notifyPaciente["title"] = "{$videoconsulta["medico_nombre"]} {$videoconsulta["medico_apellido"]} - Vidéo Consultation";
                $notifyPaciente["text"] = "Votre prochaine Vidéo Consultation commence dans moins de 5 minutes";
                $notifyPaciente["type"] = "recordatorio-proxima-vc";
                $notifyPaciente["id"] = $videoconsulta["idvideoconsulta"];
                $notifyPaciente["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                $notifyPaciente["style"] = "video-consulta";
                $client->emit('notify_php', $notifyPaciente);
            }
        }
    }

    /**
     * Metodo que retorna verdadero si el consultorio tiene permitido realizar videoconsultas
     * eso se cuemple cuando tiene creado un consultorio virtual, y definidas las tarifas para videoconsulta
     * 
     */
    public function is_permitido_videoconsulta_medico($idmedico = null) {
        if (is_null($idmedico)) {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }
        $valor_videoconsulta = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico)["valorPinesVideoConsulta"];
        $valor_videoconsulta_turno = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico)["valorPinesVideoConsultaTurno"];

        $consultorio = $this->getManager("ManagerConsultorio")->getConsultorioVirtual($idmedico);
        if (((int) $valor_videoconsulta > 0 || (int) $valor_videoconsulta_turno > 0) && (int) $consultorio["idconsultorio"] > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * metodo que retorna un array con las cantidades de consultas en los diferentes estados no leidas por el medico en sesion* */
    public function getCantidadVideoConsultasMedicoXEstado($idespecialidad = null) {

        $this->actualizarEstados();


        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $valor_videoconsulta = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico)["valorPinesVideoConsulta"];
        $valor_videoconsulta_turno = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($idmedico)["valorPinesVideoConsultaTurno"];

        $consultorio = $this->getManager("ManagerConsultorio")->getConsultorioVirtual($idmedico);
        if (((int) $valor_videoconsulta > 0 || (int) $valor_videoconsulta_turno > 0) && (int) $consultorio["idconsultorio"] > 0) {
            $result["ispermitido"] = 1;
        } else {
            $result["ispermitido"] = 0;
        }

        $result["pendientes"] = $this->db->GetOne("select count(*) as pendientes from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=1 and tipo_consulta<>2 and visualizar_consulta_medico=1 and medico_idmedico=$idmedico ");


        $result["abiertas"] = $this->db->GetOne("select count(*) as abiertas from $this->table 
                  where (estadoVideoConsulta_idestadoVideoConsulta=2 or estadoVideoConsulta_idestadoVideoConsulta=7) and visualizar_consulta_medico=1 and medico_idmedico=$idmedico ");

        $result["abiertas_total"] = $this->db->GetOne("select count(*) as abiertas_total from $this->table 
                  where (estadoVideoConsulta_idestadoVideoConsulta=2 or estadoVideoConsulta_idestadoVideoConsulta=7) and medico_idmedico=$idmedico ");

        $result["rechazadas"] = $this->db->GetOne("select count(*) as rechazadas from $this->table 
          where estadoVideoConsulta_idestadoVideoConsulta=3 and tipo_consulta<>2 and visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["rechazadas_total"] = $this->db->GetOne("select count(*) as rechazadas_total from $this->table 
          where estadoVideoConsulta_idestadoVideoConsulta=3 and tipo_consulta<>2 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["finalizadas"] = $this->db->GetOne("select count(*) as finalizadas from $this->table 
          where estadoVideoConsulta_idestadoVideoConsulta=4 and tipo_consulta<>2 and visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["finalizadas_total"] = $this->db->GetOne("select count(*) as finalizadas_total from $this->table 
          where estadoVideoConsulta_idestadoVideoConsulta=4 and tipo_consulta<>2  and medico_idmedico=$idmedico ");

        $result["vencidas"] = $this->db->GetOne("select count(*) as vencidas from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=5  and tipo_consulta<>2 and visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["vencidas_total"] = $this->db->GetOne("select count(*) as vencidas_total from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=5  and tipo_consulta<>2 and leido_medico=0 and medico_idmedico=$idmedico ");

        $result["pendientes_finalizacion"] = $this->db->GetOne("select count(*) as pendientes_finalizacion from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=8 and visualizar_consulta_medico=1  and  medico_idmedico=$idmedico ");

        $result["en_curso"] = $this->db->GetOne("select count(*) as en_curso from $this->table 
                  where ((estadoVideoConsulta_idestadoVideoConsulta=2 and SYSDATE()>=inicio_sala) or estadoVideoConsulta_idestadoVideoConsulta=7) and  medico_idmedico=$idmedico ");


        $result["red"] = $this->db->GetOne("select count(*) as red from $this->table vc where estadoVideoConsulta_idestadoVideoConsulta=1 and tipo_consulta=0 AND vc.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");

//valor que se muestra en el icono superior de CE
        $result["notificacion_general"] = (int) $result["pendientes"] + (int) $result["abiertas"] + (int) $result["pendientes_finalizacion"] + (int) $result["red"];


        return $result;
    }

    /**
     * metodo que retorna un array con las cantidades de consultas en los diferentes estados no leidas por el paciente */
    public function getCantidadVideoConsultasPacienteXEstado($idpaciente = null) {


        $this->actualizarEstados();
        if (is_null($idpaciente)) {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        }

        $result["ispermitido"] = $this->getManager("ManagerPaciente")->isPermitidoVideoConsulta($idpaciente);

        if ($result["ispermitido"] == "1") {
            $result["pendientes"] = $this->db->GetOne("select count(*) as pendientes from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=1 and tipo_consulta<>2 and  visualizar_consulta_paciente=1 and paciente_idpaciente=$idpaciente ");


            $result["abiertas"] = $this->db->GetOne("select count(*) as abiertas from $this->table 
                  where (estadoVideoConsulta_idestadoVideoConsulta=2 or estadoVideoConsulta_idestadoVideoConsulta=7) and visualizar_consulta_paciente=1  and paciente_idpaciente=$idpaciente ");

            $result["abiertas_total"] = $this->db->GetOne("select count(*) as abiertas_total from $this->table 
                  where (estadoVideoConsulta_idestadoVideoConsulta=2 or estadoVideoConsulta_idestadoVideoConsulta=7)  and paciente_idpaciente=$idpaciente ");


            $result["rechazadas"] = $this->db->GetOne("select count(*) as rechazadas from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=3 and tipo_consulta<>2 and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["rechazadas_total"] = $this->db->GetOne("select count(*) as rechazadas_total from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=3 and tipo_consulta<>2 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["finalizadas"] = $this->db->GetOne("select count(*) as finalizadas from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=4 and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["finalizadas_total"] = $this->db->GetOne("select count(*) as finalizadas_total from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=4  and paciente_idpaciente=$idpaciente ");


            $result["vencidas"] = $this->db->GetOne("select count(*) as vencidas from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=5  and tipo_consulta<>2 and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["vencidas_total"] = $this->db->GetOne("select count(*) as vencidas_total from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=5  and tipo_consulta<>2 and visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=$idpaciente ");

            $result["pendientes_finalizacion"] = $this->db->GetOne("select count(*) as pendietes_finalizacion from $this->table 
                  where estadoVideoConsulta_idestadoVideoConsulta=8 and paciente_idpaciente=$idpaciente ");

            $result["en_curso"] = $this->db->GetOne("select count(*) as en_curso from $this->table 
                  where ((estadoVideoConsulta_idestadoVideoConsulta=2 and SYSDATE()>=inicio_sala) or estadoVideoConsulta_idestadoVideoConsulta=7) and  paciente_idpaciente=$idpaciente");

            //valor que se muestra en el icono superior de CE
            $result["notificacion_general"] = (int) $result["pendientes"] + (int) $result["rechazadas"] + (int) $result["abiertas"] + (int) $result["finalizadas"] + (int) $result["vencidas"];
        }


        return $result;
    }

    /*     * Metodo que retorna el detalle de un listado de videoconsultas realizadas por el medico
     * en un periodo
     * @param array $request
     * @param type $idpaginate
     * @return type
     */

    public function getListadoPaginadoDetalleVideoConsultaXPeriodo($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }
        $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
        $periodo_pago = $ManagerPeriodoPago->get($request["idperiodoPago"]);

        $fecha_fin = date("Y-m-d 23:59:59", mktime(0, 0, 0, $periodo_pago["mes"] + 1, 0, $periodo_pago["anio"]));
        $fecha_inicio = date("Y-m-d 00:00:00", mktime(0, 0, 0, $periodo_pago["mes"], 1, $periodo_pago["anio"]));


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table ce");
        $query->setWhere("estadoVideoConsulta_idestadoVideoConsulta=4 AND ce.fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin' AND medico_idmedico = $idmedico");


        $listado = $this->getListPaginado($query, $idpaginate);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerPrestador = $this->getManager("ManagerPrestador");
        if ($listado["rows"] && count($listado["rows"]) > 0) {
            foreach ($listado["rows"] as $key => $VC) {
                if ($VC["prestador_idprestador"] != "") {
                    $listado["rows"][$key]["prestador"] = $ManagerPrestador->get($VC["prestador_idprestador"]);
                }
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($VC["paciente_idpaciente"]);
                $listado["rows"][$key]["fecha_fin_format"] = fechaToString($VC["fecha_fin"]);
            }
        }
        return $listado;
    }

    /*     * Metodo que retorna un array con las VC por especialidad ordenadas descendientemente
     * 
     */

    public function getCantidadVideoConsultaXEspecialidad($idespecialidad = null) {
        //verificamos si el medico tiene habilitada la videocosulta
        $permitido = $this->is_permitido_videoconsulta_medico();
        if (!$permitido) {
            return false;
        }
        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad, idespecialidad,especialidad");
        $query->setFrom("videoconsulta vc
                inner join filtrosbusquedavideoconsulta f on (f.videoconsulta_idvideoconsulta=vc.idvideoconsulta)
                    inner join especialidad es on (es.idespecialidad=f.especialidad_idespecialidad)");
        $query->setWhere("vc.estadoVideoConsulta_idestadoVideoConsulta=1");
        if ($idespecialidad != NULL) {
            $query->addAnd("idespecialidad=$idespecialidad");
        }
        $query->addAnd("tipo_consulta=0");
        $query->setGroupBy("idespecialidad");
        $query->setOrderBy("cantidad DESC");

        return $this->getList($query);
    }

    /**
     * Método que retorna una video consulta desde el lado del paciente
     * @param type $request
     * @return boolean
     */
    public function getVideoConsultaPaciente($request) {

        if ($request["paciente_idpaciente"] == "") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
        } else {
            $idpaciente = $request["paciente_idpaciente"];
        }

        $consulta = $this->get($request[$this->id]);

        //verificamos que la consulta pertenzeca al paciente
        $idpaciente_session = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

        $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($consulta["paciente_idpaciente"], $idpaciente_session);

        //verificamos que la consulta sea del titular o algun miembro

        if ($consulta["paciente_idpaciente"] != $idpaciente || $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != $request["idestadoVideoConsulta"]) {

            //throw new ExceptionErrorPage("No se pudo recuperar la videoconsulta");
            //redirigir  a la home
            header('Location:' . URL_ROOT . "panel-paciente/videoconsulta/");
            exit;
        }

        if (CONTROLLER == "paciente_p" && $consulta["paciente_idpaciente"] != $idpaciente_session && $familiar["pacienteGrupo"] != $consulta["paciente_idpaciente"]) {

            //throw new ExceptionErrorPage("No se pudo recuperar la videoconsulta");
            //redirigir  a la home
            header('Location:' . URL_ROOT . "panel-paciente/videoconsulta/");
            exit;
        }


        if ($consulta) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
            $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
            $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
            $ManagerRegistroInicioSala = $this->getManager("ManagerRegistroInicioSala");
            $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
            $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");

            $consulta["motivoVideoConsulta"] = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];
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

            //Diferencia de videoconsulta en segundos para el vencimiento
            if ($consulta["tipo_consulta"] == "0") {
                if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] == 1 && $consulta["fecha_vencimiento_toma"] != "") {

                    $segundos = strtotime($consulta["fecha_vencimiento_toma"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $consulta["segundos_diferencia"] = $segundos;
                    } else {
                        $consulta["segundos_diferencia"] = 0;
                    }
                }
                if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] == 1 && $consulta["fecha_vencimiento"] != "") {

                    $segundos = strtotime($consulta["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $consulta["segundos_diferencia"] = $segundos;
                    } else {
                        $consulta["segundos_diferencia"] = 0;
                    }
                }
            } else {
                if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] == 1 && $consulta["fecha_vencimiento"] != "") {

                    $segundos = strtotime($consulta["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $consulta["segundos_diferencia"] = $segundos;
                    } else {
                        $consulta["segundos_diferencia"] = 0;
                    }
                }
            }

            //Diferencia de video consulta en segundos para el inicio de la sala
            if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] == 2 && $consulta["inicio_sala"] != "") {

                $now = strtotime(date("Y-m-d H:i:s"));
                $segundos = strtotime($consulta["inicio_sala"]) - $now;
                //$segundos = (int) $segundos - (int) (5 * 60);
                if ($segundos > 0) {
                    $consulta["segundos_diferencia"] = $segundos;
                } else {
                    $consulta["segundos_diferencia"] = 0;
                }
            }
            //obtenemos las llamadas que se realizaron para las consultas interrumpidas
            if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] == 8) {
                $consulta["cant_llamadas_perdidas"] = $ManagerRegistroInicioSala->getCantidadLlamadas($consulta["idvideoconsulta"]);
            }

            //Traigo la informacion del paciente
            $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

            $consulta["medico"] = $ManagerMedico->get($consulta["medico_idmedico"], true);
            $consulta["medico"]["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
            if ($consulta["tipo_consulta"] == "0") {
                $filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $consulta["idvideoconsulta"]);
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
            $consulta["mensajes"] = $ManagerMensajeVideoConsulta->getListadoMensajes($consulta["idvideoconsulta"]);


            return $consulta;
        }
        return false;
    }

    /**
     * Listado paginado de consultas express
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoVideoConsultasMedico($request, $idpaginate = null) {

        //verificamos si el medico tiene habilitada la videocosulta
        $permitido = $this->is_permitido_videoconsulta_medico();
        if (!$permitido) {
            return false;
        }

        //las consultas pendientes de finalizacion van sin paginar
        if ($request["idestadoVideoConsulta"] != 8 && $request["idestadoVideoConsulta"] != 7) {
            if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
                $this->resetPaginate($idpaginate);
            }

            if (!is_null($idpaginate)) {
                $this->paginate($idpaginate, 10);
            }
        }
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];


        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            mr.motivoRechazo,
                            mc.motivoVideoConsulta,
                            ps.idperfilSaludConsulta
                                
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            LEFT JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                            LEFT JOIN motivovideoconsulta mc ON (mc.idmotivoVideoConsulta=t.motivoVideoConsulta_idmotivoVideoConsulta) 
                            LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo=t.motivoRechazo_idmotivoRechazo)
                                
                        ");



        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado
        if ($request["idestadoVideoConsulta"] == 2) {
            $query->addAnd("((t.estadoVideoConsulta_idestadoVideoConsulta=2)||(t.estadoVideoConsulta_idestadoVideoConsulta=7) )");
        } else {
            $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=" . $request["idestadoVideoConsulta"]);
        }



        $query->addAnd("t.visualizar_consulta_medico = 1");

        //ordenamos segun estados por tiempos restantes
        if ($request["idestadoVideoConsulta"] == 2) {
            $query->setOrderBy("t.inicio_sala ASC");
        } else if ($request["idestadoVideoConsulta"] == 1) {
            //si estan pendientes las ordenamos por la mas proxima a vencer
            $query->setOrderBy("t.fecha_vencimiento ASC");
        } else {
            $query->setOrderBy("t.fecha_inicio DESC");
        }
        //añadimos los filtros de fecha
        if ($request["idestadoVideoConsulta"] == 4) {
            if ($request["filtro_inicio"] != "") {
                $filtro_inicio = $this->sqlDate($request["filtro_inicio"]);
                $query->addAnd("t.fecha_fin >= '{$filtro_inicio}'");
            }
            if ($request["filtro_fin"] != "") {
                $filtro_fin = $this->sqlDate($request["filtro_fin"]);
                $query->addAnd("t.fecha_fin <= '{$filtro_fin}'");
            }
        }


        $query->setGroupBy("t.idvideoconsulta");
//los listados de videoconsultas sin finalizar no estan paginados
        if ($request["idestadoVideoConsulta"] == 8 || $request["idestadoVideoConsulta"] == 7) {
            $listado_aux = $this->getList($query);
            $listado["rows"] = $listado_aux;
        } else {
            $listado = $this->getListPaginado($query, $idpaginate);
        }



        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
            $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
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


                //Diferencia de video consulta en segundos para el vencimiento
                if ($request["idestadoVideoConsulta"] != 2) {
                    if ($value["tipo_consulta"] == 1 && $value["fecha_vencimiento"] != "") {

                        $segundos = strtotime($value["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                        if ($segundos > 0) {
                            $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                        } else {
                            $listado["rows"][$key]["segundos_diferencia"] = 0;
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
                } else {//Diferencia de video consulta en segundos para el inicio de la salaa
                    if ($value["inicio_sala"] != "") {

                        $now = strtotime(date("Y-m-d H:i:s"));

                        $segundos = strtotime($value["inicio_sala"]) - $now;
                        //$segundos = (int) $segundos - (int) (5 * 60);
                        if ($segundos > 0) {

                            $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                        } else {

                            $listado["rows"][$key]["segundos_diferencia"] = 0;
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


                $listado["rows"][$key]["medico"]["image"] = $imagen_medico;
                //si la videoconsulta es con turno, traigo los mnesajes del turno
                if ($value["turno_idturno"] != "") {
                    $listado["rows"][$key]["mensajes"][] = $ManagerMensajeTurno->getListadoMensajes($value["turno_idturno"], $value["paciente_idpaciente"]);
                    //sumamos los mensajes durante la VC
                    $listado["rows"][$key]["mensajes"] = array_merge($listado["rows"][$key]["mensajes"], $ManagerMensajeVideoConsulta->getListadoMensajes($value["idvideoconsulta"]));
                } else {
                    //traigo los mensajes de la videoconsulta
                    $listado["rows"][$key]["mensajes"] = $ManagerMensajeVideoConsulta->getListadoMensajes($value["idvideoconsulta"]);
                }



//verificamos si la consulta es el dia de hoy
                $timestampActual = time();
                $timestampInicioSala = strtotime($listado["rows"][$key]["inicio_sala"]);

                if (abs($timestampInicioSala - $timestampActual) / (60 * 60) > 12) {
                    $listado["rows"][$key]["fecha_futura"] = 1;
                }
                $dia = date("d", strtotime($listado["rows"][$key]["inicio_sala"]));
                $mes = date("m", strtotime($listado["rows"][$key]["inicio_sala"]));

                $nombre_dia = getDiaSemanaXFecha($listado["rows"][$key]["inicio_sala"]);

                $nombre_dia = substr($nombre_dia, 0, 3);
                //$nombre_mes = getNombreMes($mes);

                $listado["rows"][$key]["fecha_futura_format"] = "{$nombre_dia} {$dia}";
            }



            return $listado;
        }
    }

    /**
     * Listado paginado de video consultas
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoVideoConsultasPaciente($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];


        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            mr.motivoRechazo,
                            mc.motivoVideoConsulta,
                            ps.idperfilSaludConsulta
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            LEFT JOIN motivovideoconsulta mc ON (mc.idmotivoVideoConsulta=t.motivoVideoConsulta_idmotivoVideoConsulta) 
                            LEFT JOIN motivorechazo mr ON (mr.idmotivoRechazo=t.motivoRechazo_idmotivoRechazo)
                                                        LEFT JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta)
                                                            
                        ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        //estado
        if ($request["idestadoVideoConsulta"] == 4) {
            //filtramos por el estado finalizadas o pendientes de finalizacion
            $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4 OR t.estadoVideoConsulta_idestadoVideoConsulta=8");
            //añadimos los filtros de fecha
            if ($request["filtro_inicio"] != "") {
                $filtro_inicio = $this->sqlDate($request["filtro_inicio"]);
                $query->addAnd("t.fecha_fin >= '{$filtro_inicio}'");
            }
            if ($request["filtro_fin"] != "") {
                $filtro_fin = $this->sqlDate($request["filtro_fin"]);
                $query->addAnd("t.fecha_fin <= '{$filtro_fin}'");
            }
        } else if ($request["idestadoVideoConsulta"] == 2) {
            $query->addAnd("((t.estadoVideoConsulta_idestadoVideoConsulta=2)||(t.estadoVideoConsulta_idestadoVideoConsulta=7) )");
        } else {
            $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=" . $request["idestadoVideoConsulta"]);
        }
        //las video consultas que son sacadas por turno solo se listan con las finalizadas
        //if ($request["idestadoVideoConsulta"] != 4) {
        //   $query->addAnd("t.tipo_consulta <> 2");
        // }
        $query->addAnd("visualizar_consulta_paciente = 1");


        //ordenamos segun estados por tiempos restantes
        if ($request["idestadoVideoConsulta"] == 2) {
            $query->setOrderBy("t.inicio_sala ASC");
        } else if ($request["idestadoVideoConsulta"] == 1) {
            //si estan pendientes las ordenamos por la mas proxima a vencer
            $query->setOrderBy("t.fecha_vencimiento ASC");
        } else {
            $query->setOrderBy("t.fecha_inicio DESC");
        }

        $query->setGroupBy("t.idvideoconsulta");
        $listado = $this->getListPaginado($query, $idpaginate);


        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
            $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
            $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
            $ManagerRegistroInicioSala = $this->getManager("ManagerRegistroInicioSala");

            $ManagerPerfilSaludReceta = $this->getManager("ManagerPerfilSaludReceta");
            $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
            $ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
            $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
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


                //Traigo la informacion del medico
                $listado["rows"][$key]["paciente"] = $ManagerPaciente->get($value["paciente_idpaciente"]);

                $listado["rows"][$key]["medico"] = $ManagerMedico->get($value["medico_idmedico"], true);
                $listado["rows"][$key]["medico"]["imagen"] = $ManagerMedico->getImagenMedico($value["medico_idmedico"]);
                if ($value["tipo_consulta"] == "0") {
                    $filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $value["idvideoconsulta"]);
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
                //Diferencia de videoconsulta en segundos para el vencimiento
                if ($value["estadoVideoConsulta_idestadoVideoConsulta"] == 1 && $value["fecha_vencimiento"] != "") {

                    $segundos = strtotime($value["fecha_vencimiento"]) - strtotime(date("Y-m-d H:i:s"));
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = 0;
                    }
                }

                //Diferencia de video consulta en segundos para el inicio de la sala
                if ($value["estadoVideoConsulta_idestadoVideoConsulta"] == 2 && $value["inicio_sala"] != "") {

                    $now = strtotime(date("Y-m-d H:i:s"));
                    $segundos = strtotime($value["inicio_sala"]) - $now;
                    //$segundos = (int) $segundos - (int) (5 * 60);
                    if ($segundos > 0) {
                        $listado["rows"][$key]["segundos_diferencia"] = $segundos;
                    } else {
                        $listado["rows"][$key]["segundos_diferencia"] = 0;
                    }
                }
                //obtenemos las llamadas que se realizaron para las consultas interrumpidas
                if ($value["estadoVideoConsulta_idestadoVideoConsulta"] == 8) {
                    $listado["rows"][$key]["cant_llamadas_perdidas"] = $ManagerRegistroInicioSala->getCantidadLlamadas($value["idvideoconsulta"]);
                }
                //veo si tiene recetas agregadas
                if ($value["estadoVideoConsulta_idestadoVideoConsulta"] == 4) {
                    $listado["rows"][$key]["posee_receta"] = $ManagerPerfilSaludReceta->posee_receta($value["idperfilSaludConsulta"]);
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

                //si la videoconsulta es con turno, traigo los mensajes del turno
                if ($value["turno_idturno"] != "") {
                    $listado["rows"][$key]["mensajes"][] = $ManagerMensajeTurno->getListadoMensajes($value["turno_idturno"], $value["paciente_idpaciente"]);
                    //sumamos los mensajes durante la VC
                    $listado["rows"][$key]["mensajes"] = array_merge($listado["rows"][$key]["mensajes"], $ManagerMensajeVideoConsulta->getListadoMensajes($value["idvideoconsulta"]));
                } else {
                    //traigo los mensajes de la consulta
                    $listado["rows"][$key]["mensajes"] = $ManagerMensajeVideoConsulta->getListadoMensajes($value["idvideoconsulta"]);
                }
                //verificamos si la consulta es el dia de hoy
                $timestampActual = time();
                $timestampInicioSala = strtotime($listado["rows"][$key]["inicio_sala"]);

                if (abs($timestampInicioSala - $timestampActual) / (60 * 60) > 12) {
                    $listado["rows"][$key]["fecha_futura"] = 1;
                }
                $dia = date("d", strtotime($listado["rows"][$key]["inicio_sala"]));
                $mes = date("m", strtotime($listado["rows"][$key]["inicio_sala"]));

                $nombre_dia = getDiaSemanaXFecha($listado["rows"][$key]["inicio_sala"]);
                $nombre_dia = substr($nombre_dia, 0, 3);
                //$nombre_mes = getNombreMes($mes);
                $listado["rows"][$key]["fecha_futura_format"] = "{$nombre_dia} {$dia}";
            }

            return $listado;
        }
    }

    /**
     * Metodo que devuelve el contador de consultas en la red en la que estuvo asignado el medico
     * @return type
     */
    public function getHistoricoVideoConsultasRed() {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        $consulta_red_historica = $this->db->GetOne("select count(*) as red from videoconsulta vc where estadoVideoConsulta_idestadoVideoConsulta<>1  AND tipo_consulta=0 AND vc.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");
        return $consulta_red_historica;
    }

    /**
     * Listado paginado de video consultas en la bolsa de medicos
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPaginadoVideoConsultasRed($request, $idpaginate = null) {
//verificamos si el medico tiene habilitada la videocosulta
        $permitido = $this->is_permitido_videoconsulta_medico();
        if (!$permitido) {
            return false;
        }
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
        //puede venir una especialidad en el request o varias concatenadas por ',' en el filtro de busqueda
        //si no vienen seteadas las especialidades en el request las obtenemos del medico
        if ($request["from_filtro"] == "1" && isset($request["idespecialidad"])) {

            //$especialidades = implode(",", $request["idespecialidad"]);
        } else {

            //$especialidades = implode(",", $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesList($idmedico, true));
        }
        /**
         * Status 1=medico incluido en la bola
         *  Status 2 =medico no incluido porque no cumple con el rango de precios
         *  Status 2 =medico no incluido porque no cumple con los parametros de busqueda
         * * */
        $query = new AbstractSql();

        $query->setSelect("
		vc.*, 
                f.rango_minimo,
                mc.motivoVideoConsulta,
                f.rango_maximo,
                CASE 
                    WHEN vc.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%')) THEN 1 
                     ELSE GetExcluidoRangoPrecioVC($idmedico,f.rango_minimo,f.rango_maximo) 
                END as status
		      ");
        $query->setFrom("videoconsulta vc
		INNER JOIN filtrosbusquedavideoconsulta f ON (f.videoconsulta_idvideoconsulta = vc.idvideoconsulta)
                LEFT JOIN motivovideoconsulta mc ON (mc.idmotivoVideoConsulta = vc.motivoVideoConsulta_idmotivoVideoConsulta)"
        );
        $query->setWhere("vc.tipo_consulta = 0");
        $query->addAnd("(vc.estadoVideoConsulta_idestadoVideoConsulta = 1) OR (vc.estadoVideoConsulta_idestadoVideoConsulta = 2 and tomada=1)");

        $query->addAnd("vc.ids_medicos_bolsa LIKE (CONCAT('%,',$idmedico,',%'))");


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

        $query->setOrderBy("vc.fecha_inicio DESC");




        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
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
                $listado["rows"][$key]["mensajes"] = $ManagerMensajeVideoConsulta->getListadoMensajes($value["idvideoconsulta"]);
            }


            return $listado;
        }
    }

    /*     * Metodo que retorna la proxima videoconsulta a la cual restan 5 minutos del inicio para el acceso a la sala
     * 
     */

    public function getProximaVideoConsulta() {

        $this->actualizarEstados();
        if (CONTROLLER == "medico") {
            //obtenemos la videoconsulta asignada al medico
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

            $query = new AbstractSql();
            $query->setSelect("*");
            $query->setFrom("$this->table");
            $query->setWhere(" ((estadoVideoConsulta_idestadoVideoConsulta=7 ) or (estadoVideoConsulta_idestadoVideoConsulta=2 ) or (estadoVideoConsulta_idestadoVideoConsulta=1 and tipo_consulta=0 and tomada=1))");
            //$query->addAnd("DATE_ADD(SYSDATE(),INTERVAL 5 MINUTE) > inicio_sala");
            $query->addAnd("medico_idmedico=$idmedico");
            $query->setOrderBy("inicio_sala");
        }
        if (CONTROLLER == "paciente_p") {
            $idpaciente = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];

            //obtenemos la videoconsulta del paciente en sesion o algun miembro de su grupo familiar
            $query = new AbstractSql();
            $query->setSelect("vc.*,IFNULL(pgf.pacienteTitular,vc.paciente_idpaciente)as idpaciente");
            $query->setFrom("$this->table vc LEFT JOIN pacientegrupofamiliar pgf on (vc.paciente_idpaciente=pgf.pacienteGrupo) ");
            $query->setWhere(" ((estadoVideoConsulta_idestadoVideoConsulta=7 ) or (estadoVideoConsulta_idestadoVideoConsulta=2)or (estadoVideoConsulta_idestadoVideoConsulta=1 and tipo_consulta=0 and tomada=1))");
            // $query->addAnd("DATE_ADD(SYSDATE(),INTERVAL 5 MINUTE) > inicio_sala");
            $query->addAnd("IFNULL(pgf.pacienteTitular,vc.paciente_idpaciente)=$idpaciente");
            $query->setOrderBy("inicio_sala");
        }


        $videoconsulta = $this->db->getRow($query->getSql());

        return $videoconsulta["idvideoconsulta"];
    }

    /**
     * Metodo que retorna la siguiente consulta abierta en la sala de espera si existe, respecto de la consulta actual en la sala
     * Este metodo se utiliza para que no se superpongan los 20 min de duracion de una consulta, con el inicio de la siguiente
     * @param type $idvideoconsulta
     */
    public function getSiguienteConsultaAbierta($idvideoconsulta) {
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("estadoVideoConsulta_idestadoVideoConsulta=2 and medico_idmedico=$idmedico and idvideoconsulta<>$idvideoconsulta");
        $query->setOrderBy("inicio_sala ASC");
        //si son varias, se devuelve la inmedita siguiente
        $rdo = $this->getList($query);
        return $rdo[0];
    }

    /** Incrementa el contador de visualizaciones de videoconsultas pendientes en la red
     * 
     * @param type $idvideoconsulta
     */
    public function marcarVisto($idvideoconsulta) {

        $this->db->StartTrans();
        $update = "UPDATE $this->table set visualizaciones = (visualizaciones + 1)  where idvideoconsulta = $idvideoconsulta";

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

    /* metodo que setea las notificaciones de video consulta como leidas segun su estado, cuando el medico ingresa a la bandeja de entrada * */

    public function setNotificacionesLeidasMedico($request) {

        //seteamos como leida una consulta en particular si viene el id
        if (isset($request["idvideoconsulta"]) && $request["idvideoconsulta"] != "") {
            $this->db->Execute("update $this->table set leido_medico=1,visualizaciones=1 where idvideoconsulta=" . $request["idvideoconsulta"]);
            $videoconsulta = $this->get($request["idvideoconsulta"]);
            $client = new XSocketClient();
            $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);
        } else {
            //seteamos como leidas todas las pertenecientes a una bandeja
            $idestado = $request["idestadoVideoConsulta"];
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $this->db->Execute("update $this->table set leido_medico=1 where estadoVideoConsulta_idestadoVideoConsulta=$idestado  
                and medico_idmedico=$idmedico ");
        }
    }

    /* metodo que setea las notificaciones de video consulta como leidas segun su estado, cuando el paciente ingresa a la bandeja de entrada * */

    public function setNotificacionesLeidasPaciente($request) {


        //seteamos como leida una consulta en particular si viene el id
        if (isset($request["idvideoconsulta"]) && $request["idvideoconsulta"] != "") {
            $rdo = $this->db->Execute("update $this->table set leido_paciente=1 where idvideoconsulta=" . $request["idvideoconsulta"]);

            /* $videoconsulta = $this->get($request["idvideoconsulta"]);
              $client = new XSocketClient();
              $client->emit("cambio_estado_videoconsulta_php", $videoconsulta); */
        } else {
            //seteamos como leidas todas las pertenecientes a una bandeja
            $idestado = $request["idestadoVideoConsulta"];
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idpaciente = $paciente["idpaciente"];
            $rdo = $this->db->Execute("update $this->table set leido_paciente=1 where estadoVideoConsulta_idestadoVideoConsulta=$idestado  
                and paciente_idpaciente=$idpaciente");
        }

        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Consulta leída"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error"]);
            return false;
        }
    }

    /**
     * Pertenece al conjunto de metodos que crean la video consulta por parte de un paciente paso por paso
     * 
     * se establece en este paso si esta dirigida a profesionales en la red o a un medioc frecuente.
     * @param type $request
     */
    public function processVideoConsultaStep1($request) {


        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $request["paciente_idpaciente"] = $idpaciente;
        $request["estadoVideoConsulta_idestadoVideoConsulta"] = 6;

        $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
        if ($request["tipo_consulta"] == "0" || $request["tipo_consulta"] == "1") {
            $this->db->StartTrans();
            $request["consulta_step"] = 2;
            //verificamos si se esta actualizando una consulta o creando

            if (isset($request["idvideoconsulta"]) && $request["idvideoconsulta"] != "") {

                //validamos la consulta que pertenezca al paciente y este en borrador
                $vc = $this->get($request["idvideoconsulta"]);

                if ($vc["paciente_idpaciente"] != $idpaciente || $vc["estadoVideoConsulta_idestadoVideoConsulta"] != 6) {
                    $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                    return false;
                }
                $request["numeroVideoConsulta"] = STR_PAD($request["VideoConsulta"], 7, "0", STR_PAD_LEFT);
                $consulta = parent::update($request, $request["idvideoconsulta"]);
            } else {
                //creamos una consulta nueva
                $id = parent::insert($request);
                //creamos el numero de video consulta formateado
                $record["numeroVideoConsulta"] = STR_PAD($id, 7, "0", STR_PAD_LEFT);
                $request["idvideoconsulta"] = $id;
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
            $filtros = $ManagerFiltrosBusquedaVideoConsulta->insert($request);
            if (!$filtros) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta"]);
                return false;
            }
            //asignamos los medicos de la especialidad si es consulta en la red
            if ($request["tipo_consulta"] == 0) {
                $medico_red = $this->processVideoConsultaStep2ProfesionalRed($request);
                if (!$medico_red) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha creado la videoconsulta con éxito", "result" => true, "id" => $request["idvideoconsulta"]]);
            return $consulta;
        } else {
            $this->setMsg(["result" => false, "msg" => "Seleccione a quien está dirigida la video consulta"]);
            return false;
        }
    }

    /* Metodo que setea los medicos en la bolsa para la consulta express
     * 
     */

    public function processVideoConsultaStep2ProfesionalRed($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;
        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idvideoconsulta"]);


        if ($request["idvideoconsulta"] == "" || !$this->validarVideoConsultaPacienteSesion($request["idvideoconsulta"]) || $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
            return false;
        }


        $ids = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getIdsMedicosBolsa($request["idvideoconsulta"]);

        if ($ids == "") {
            $this->setMsg(["msg" => "Error. No hay profesionales para asignar la consulta", "result" => false, "no_profesionales" => 1]);

            return false;
        } else {
            $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $request["idvideoconsulta"]);

            $request["ids_medicos_bolsa"] = $ids;
            $request["consulta_step"] = 3;
            $request["idprograma_categoria"] = $filtro["idprograma_categoria"];
            $rdo = parent::update($request, $request["idvideoconsulta"]);
        }
        if ($rdo) {
            $this->setMsg(["msg" => "Profesionales asignados con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se han guardar los profesionales", "result" => false]);

            return false;
        }
    }

    /* Metodo que setea el medico al que esta asignada la video consulta
     * 
     */

    public function processVideoConsultaStep2ProfesionalFrecuente($request) {

        if ($request["idvideoconsulta"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta", "result" => false]);

            return false;
        }

        if ($request["medico_idmedico"] != "") {
            //La video consulta se hace a médico frecuente
            //Debo controlar que el médico no haya cambiado la preferencia, lo controlo con el rango_maximo
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $preferencia = $ManagerPreferencia->getPreferenciaMedico($request["medico_idmedico"]);
            if ($preferencia && (int) $preferencia["valorPinesVideoConsulta"] > 0) {



                $request["precio_tarifa"] = (int) $preferencia["valorPinesVideoConsulta"];
                $request["consulta_step"] = 3;


                return parent::update($request, $request["idvideoconsulta"]);
            } else {
                $this->setMsg(["msg" => "Error. El médico no posee configurada el precio de la video consulta", "result" => false]);

                return false;
            }
        } else {
            $this->setMsg(["msg" => "Error. No se ha seleccionado el medico", "result" => false]);

            return false;
        }
    }

    /*     * Metodo que crea una videoconsulta sin pasar por el proceso de busqueda , seleccionando directamente un medico
     * viene del listado de profesionales frecuentes o la ficha del medico y para ser creada directamente a ese profesional       
     * o  viene de profesonales en la red y se selecciona solo un medico del listado
     * @param type $request
     * @return boolean
     */

    public function set_medico_videoconsulta($request) {

        $request["consulta_step"] = 3;

        if ($request["medico_idmedico"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar el medico"]);
            return false;
        }
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($request["medico_idmedico"]);
        //verificamos si el medico  acepta VC
        if ($preferencia["valorPinesVideoConsulta"] == "") {

            $this->setMsg(["result" => false, "msg" => "El médico no ofrece servicio de Video Consulta"]);
            return false;
        }

//verificamos si el medico solo acepta VC a  sus pacientes
        if ($preferencia["pacientesVideoConsulta"] == 2) {
            //verificamos que sea un paciente frecuente del medico
            $frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($request["medico_idmedico"], $idpaciente);
            if (!$frecuente) {
                $this->setMsg(["result" => false, "msg" => "El médico solo ofrece servicio de Video Consulta a sus pacientes frecuentes"]);
                return false;
            }
        }
//si no viene el id de videoconsulta la debemos crear, porque viene del listado de profesionales frecuentes o la ficha del medico
        //para ser creada directamente a ese profesional sin pasar por el proceso de busqueda 
        if ((!isset($request["idvideoconsulta"])) || $request["idvideoconsulta"] == "") {

            $request["paciente_idpaciente"] = $idpaciente;
            $request["estadoVideoConsulta_idestadoVideoConsulta"] = 6;
            $request["tipo_consulta"] = 1;

            //obtnememos la tarifa del medico
            $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"]);
            if ($medico["active"] != 1 || $medico["validado"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
                return false;
            }

            //verificamos si el paciente puede hacer consultas al medico segun su pais
            if ($paciente["pais_idpais"] == 1 && $paciente["pais_idpais_trabajo"] != 2 && $medico["pais_idpais"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Usted solo puede consultar a médicos de Francia"]);
                return false;
            }

            $request["precio_tarifa"] = $preferencia["valorPinesVideoConsulta"];
            $rdo = $this->deleteBorrador($idpaciente);
            $rdo1 = $this->process($request);
            if ($rdo && $rdo1) {
                $this->setMsg(["result" => true, "msg" => "Video Consulta creada con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
                return false;
            }
        } else {
            //si esta seteado el id de la VC, es una consulta ya existente, de profesonales en la red 
            //que se selecciona solo un medico del listado
            $request["ids_medicos_bolsa"] = "," . $request["medico_idmedico"] . ",";
            //obtnememos la tarifa del medico
            $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"]);
            if ($medico["active"] != 1 || $medico["validado"] != 1) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
                return false;
            }
            $preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);
            unset($request["medico_idmedico"]);

            $rdo = $this->update($request, $request["idvideoconsulta"]);

            //actualizamos el filtro de busqueda con la tarifa del medico
            $ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
            $filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $request["idvideoconsulta"]);
            $rdo1 = $ManagerFiltrosBusquedaVideoConsulta->update(["rango_maximo" => $preferencia["valorPinesVideoConsulta"], "rango_minimo" => $preferencia["valorPinesVideoConsulta"]], $filtro["idfiltrosBusquedaVideoConsulta"]);
            if ($rdo && $rdo1) {
                $this->setMsg(["result" => true, "msg" => "Video Consulta creada con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
                return false;
            }
        }
    }

    /*     * Metodo que cancela el pago de una video consulta, para retornar al paso de seleccion de medico
     * 
     * @param type $request
     */

    public function cancelarPago($request) {

        if ($request["idvideoconsulta"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta", "result" => false]);

            return false;
        } else {

            // <-- LOG
            $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
            $log["page"] = "Home page (connected)";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Cancel Video Consultation request with connected Frequent Professional";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 
            return parent::update(["medico_idmedico" => "", "ids_medicos_bolsa" => "", "precio_tarifa" => "", "consulta_step" => 1], $request["idvideoconsulta"]);
        }
    }

    /*
     * Metodo que confirma el pago de la video consulta seteando el paso siguiente
     * 
     * @param type $request
     */

    public function confirmarPago($request) {



        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;

        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idvideoconsulta"]);

        if ($request["idvideoconsulta"] == "" || $consulta["paciente_idpaciente"] != $idpaciente || $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la video consulta a actualizar "]);
            return false;
        }

        $this->db->StartTrans();

        //Fechas de vencimiento
        $request["fecha_inicio"] = date("Y-m-d H:i:s");
        if ($consulta["tipo_consulta"] == "0") {
            //Profesionales en la red
            $request["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_VC_RED . " hour", strtotime($request["fecha_inicio"]));
        } else {
            //Profesionales frecuentes
            $request["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_VC_FRECUENTES . " hour", strtotime($request["fecha_inicio"]));
        }

        //Confirmada publicada
        $request["consulta_step"] = 5;

        $rdo = parent::update($request, $request["idvideoconsulta"]);


        if ($rdo) {
            $mis_pacientes = true;
            if ($consulta["tipo_consulta"] == "0") {
                //Profesionales en la red, es el rango máximo de filtro
                $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $request["idvideoconsulta"]);
                $request["rango_maximo"] = $filtro["rango_maximo"];
            } else {
                //Precio de la tarifa del médico
                if ($request["beneficia_reintegro"] == 1) {

                    $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                    $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"], true);
                    $tarifa_videconsulta = $this->getManager("ManagerGrilla")->getTarifaVideoConsulta($paciente, $medico);

                    if ($tarifa_videconsulta["grilla"]["idgrilla_excepcion"] != "") {
                        $record["grilla_excepcion_idgrilla_excepcion"] = $tarifa_videconsulta["grilla"]["idgrilla_excepcion"];
                        $record["grilla_idgrilla"] = $tarifa_videconsulta["grilla"]["grilla_idgrilla"];
                    }
                    if ($tarifa_videconsulta["grilla"]["idgrilla"] != "") {
                        $record["grilla_idgrilla"] = $tarifa_videconsulta["grilla"]["idgrilla"];
                    }

                    $request["precio_tarifa"] = $tarifa_videconsulta["monto"];
                    $record["precio_tarifa"] = $tarifa_videconsulta["monto"];

                    $rdo_upd = parent::update($record, $request["idvideoconsulta"]);
                    if (!$rdo_upd) {
                        $this->setMsg(["msg" => "Error. Se produjo un error al actualizar el monto", "result" => false]);

                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                } else {
                    $request["precio_tarifa"] = $consulta["precio_tarifa"];
                }

                //insertamos el paciente al medico para que pueda visualizar el PF salud
                $mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $consulta["medico_idmedico"], "paciente_idpaciente" => $consulta["paciente_idpaciente"]]);
                $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert(["medico_idmedico" => $consulta["medico_idmedico"], "paciente_idpaciente" => $consulta["paciente_idpaciente"]]);
            }



            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
            if ($request["recompensa"] != '1') {
                $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionVC($request);
            } else {
                $vc = $this->get($request["idvideoconsulta"]);
                $pro_cat = $this->getManager("ManagerProgramaSaludCategoria")->get($vc["idprograma_categoria"]);
                $recompensaGanada = $this->getManager("ManagerGanadoresRecompensa")->getRecompensByIdPrograma($pro_cat["programa_salud_idprograma_salud"]);

                $rdo = $this->getManager("ManagerGanadoresRecompensa")->update(["recompensa_utilizada" => '2'], $recompensaGanada["idganadorrecompensa"]);

                $movimiento_cuenta = false;
            }

            if ($movimiento_cuenta || $request["recompensa"] == '1') {

                $cambio_estado = $this->cambiarEstado(["estadoVideoConsulta_idestadoVideoConsulta" => 1, "idvideoconsulta" => $request["idvideoconsulta"]]);

                if ($cambio_estado && $mis_pacientes) {
                    $this->setMsg(["msg" => "La video consulta fue creada con éxito", "result" => true]);

                    $client = new XSocketClient();
                    //enviamos el mail al/los medicos asociados 
                    $this->enviarMailNuevaVC($request["idvideoconsulta"]);
                    $this->enviarSMSNuevaVC($request["idvideoconsulta"]);
                    //si es una VC a una profesional frecuentes avisamos por SMS tambien
                    if ($consulta["medico_idmedico"] != "" && $consulta["tipo_consulta"] == "1") {

                        //notify
                        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Nouvelle demande en Visio  ";
                        $notify["type"] = "nueva-vc";
                        $notify["id"] = $request["idvideoconsulta"];
                        $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                        $notify["style"] = "video-consulta";
                        $client->emit('notify_php', $notify);
                    }

                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Consulta publicada con éxito", "result" => true]);


                    // <-- LOG
                    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
                    $log["page"] = "Home page (connected)";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Send Video Consultation request to connected Frequent Professiona";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 
                    //evento de cambio de estado

                    $client->emit('cambio_estado_videoconsulta_php', $consulta);
                    //evento de nueva consulta en la red
                    if ($consulta["tipo_consulta"] == "0") {
                        //$client->emit('cambio_estado_consultaexpress_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                        //emitimos una notificacion a los medicos de la red seleccionados
                        if ($consulta["ids_medicos_bolsa"] != "") {
                            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";

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
                            $notify["type"] = "nueva-vc-red";
                            $notify["style"] = "video-consulta";

                            $ids_medicos = explode(',', $consulta["ids_medicos_bolsa"]);
                            foreach ($ids_medicos as $id) {
                                if ($id != "") {
                                    $notify["medico_idmedico"] = $id;
                                    $client->emit('notify_php', $notify);
                                }
                            }
                        }
                    }



                    return $request["idvideoconsulta"];
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
            $this->setMsg(["msg" => "Error. No se pudo insertar la video consulta", "result" => false]);

            return false;
        }
    }

    /**
     * Metodo que emite un evento al servidor de websockets para obtener el contador de cantidades de consultas
     */
    public function obtener_contador_videoconsultas_socket() {
        $client = new XSocketClient();
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $client->emit('cambio_estado_videoconsulta_php', ["medico_idmedico" => $idmedico]);
        $this->setMsg(["msg" => "Mensaje creado con exito", "result" => true]);
        return true;
    }

    /**
     * Método que inserta el texto de la video consulta por parte de un paciente
     * Tener en cuenta que la video consulta podrá a todos los profesionales de la red o no...
     * @param type $request
     */
    public function publicarVideoConsulta($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];
        $request["paciente_idpaciente"] = $idpaciente;
        //validamos la consulta que pertenezca al paciente y este en borrador
        $consulta = $this->get($request["idvideoconsulta"]);

        if ($request["idvideoconsulta"] == "" || !$this->validarVideoConsultaPacienteSesion($request["idvideoconsulta"]) || $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != 6) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
            return false;
        }

        if ($request["motivoVideoConsulta_idmotivoVideoConsulta"] == "") {
            $this->setMsg(["result" => false, "msg" => "Seleccione el motivo de su video consulta"]);
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
        $this->db->Execute("delete from mensajevideoconsulta where videoconsulta_idvideoconsulta=" . $request["idvideoconsulta"]);

        //Debo insertar el mensaje
        $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
        $request["videoconsulta_idvideoconsulta"] = $request["idvideoconsulta"];
        $insert_mensaje = $ManagerMensajeVideoConsulta->insert($request);

        if (!$insert_mensaje) {
            $this->setMsg(["msg" => "Error. No se pudo insertar el mensaje de la video consulta", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }


        $request["estadoVideoConsulta_idestadoVideoConsulta"] = 6;
        $request["consulta_step"] = 4;
        $rdo = parent::update($request, $request["idvideoconsulta"]);

        if ($rdo) {

            $this->setMsg(["msg" => "Mensaje creado con exito",
                "result" => true
            ]);

            $this->db->CompleteTrans();
            return $request["idvideoconsulta"];
        } else {

            $this->db->FailTrans();
            $this->db->CompleteTrans();

            $this->setMsg(["msg" => "Error. No se pudo insertar la video consulta", "result" => false]);
            return false;
        }
    }

    /**
     * Rechazo de la video consulta, 
     * se debe cambiar el estado de la Video Consulta
     * enviar al process de los movimientos de la video consulta
     * @param type $request
     */
    public function rechazarVideoConsulta($request) {

        if ((int) $request["videoconsulta_idvideoconsulta"] > 0 && (int) $request["motivoRechazo_idmotivoRechazo"] > 0) {
            $videoconsulta = $this->get($request["videoconsulta_idvideoconsulta"]);

            //validamos la existencia del la video consultapendiente
            if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "1" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "2" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "7") {
                $this->setMsg(["msg" => "Error. La video consulta no se encuentra pendiente", "result" => false]);
                return false;
            }

            if ($videoconsulta) {

                $this->db->StartTrans();

                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $rechazar_consulta = $ManagerMovimientoCuenta->processRechazarPublicacionVC($videoconsulta);
                if ($rechazar_consulta) {

                    if ($request["mensaje"] != "") {
                        //insertamos el mensaje del medico
                        $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
                        $request["repuesta_desde_consulta"] = 1;
                        $request["rechazar"] = 1;
                        $request["idvideoconsulta"] = $request["videoconsulta_idvideoconsulta"];
                        $mensaje = $ManagerMensajeVideoConsulta->insert($request);
                        if (!$mensaje) {
                            $this->setMsg(["msg" => "Error. No se pudo declinar la video consulta.",
                                "result" => false
                            ]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                    //cambiamos el estado a declinado
                    $cambio_estado = $this->cambiarEstado([
                        "estadoVideoConsulta_idestadoVideoConsulta" => 3,
                        "idvideoconsulta" => $videoconsulta[$this->id],
                        "motivoRechazo_idmotivoRechazo" => $request["motivoRechazo_idmotivoRechazo"]]);
                    if ($cambio_estado) {
                        //si la videoconsulta tiene turno, lo cancelamos
                        if ($videoconsulta["turno_idturno"] != "") {
                            //Cuando el médico cambia el estado, genero una notificación para el paciente
                            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                            $ManagerTurno = $this->getManager("ManagerTurno");
                            $record["idturno"] = $videoconsulta["turno_idturno"];
                            $record["estado"] = 3;
                            $rdo_insert_notificacion = $ManagerNotificacion->createNotificacionFromCambioEstadoTurno($record);
                            $upd_turno = $ManagerTurno->update(["estado" => 3], $videoconsulta["turno_idturno"]);
                            if (!$upd_turno) {
                                $this->setMsg(["msg" => "Error. No se pudo declinar la video consulta.",
                                    "result" => false
                                ]);
                                $this->db->FailTrans();
                                $this->db->CompleteTrans();
                                return false;
                            }
                            //notificamos el evento al socket
                            $turno = $ManagerTurno->get($videoconsulta["turno_idturno"]);
                            $client = new XSocketClient();
                            $client->emit('cambio_estado_turno_php', $turno);
                        }


                        // <-- LOG
                        $log["data"] = "reason for declining, date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
                        $log["page"] = "Video Consultation";
                        $log["action"] = "val"; //"val" "vis" "del"
                        $log["purpose"] = "Decline Video Consultation request RECEIVED";

                        $ManagerLog = $this->getManager("ManagerLog");
                        $ManagerLog->track($log);
                        // 

                        $this->enviarMailRechazoVC($request["videoconsulta_idvideoconsulta"]);
                        $this->enviarSMSRechazoVC($request["videoconsulta_idvideoconsulta"]);

                        $this->setMsg(["msg" => "La video consulta fue declinada con éxito", "result" => true]);
                        $this->db->CompleteTrans();
                        $client = new XSocketClient();
                        $client->emit('cambio_estado_videoconsulta_php', $videoconsulta);

                        //notify
                        $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Vidéo Consultation déclinée";
                        $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                        $notify["style"] = "video-consulta";
                        $notify["id"] = $videoconsulta["idvideoconsulta"];
                        $client->emit('notify_php', $notify);
                        return $videoconsulta[$this->id];
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
        $this->setMsg(["msg" => "Error. No se pudo declinar la video consulta.",
            "result" => false
        ]);
        return false;
    }

    /*     * Metodo para crear una consulta express directamente a un medico sin pasar por la busqueda
     * se accede por el icono de consulta expres del medico 
     *  
     */

    public function createVideoConsultaByMedico($idmedico) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $idpaciente = $paciente["idpaciente"];

        $idpaciente_session = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        $borrador = $this->getVideoConsultaBorrador($idpaciente_session);

        if ($borrador["idvideoconsulta"] != "") {
            $this->setMsg(["msg" => "Ud. tiene una Video Consulta en proceso", "result" => false, "borrador" => 1]);
            return false;
        }
        $record["medico_idmedico"] = $idmedico;
        $record["consulta_step"] = 3;
        $record["paciente_idpaciente"] = $idpaciente;
        $record["tipo_consulta"] = 1;
        $record["estadoVideoConsulta_idestadoVideoConsulta"] = 6; //borrador
        $ManagerPreferencia = $this->getManager("ManagerPreferencia");
        $preferencia = $ManagerPreferencia->getPreferenciaMedico($idmedico);
        $record["precio_tarifa"] = (int) $preferencia["valorPinesVideoConsulta"];

        $rdo = parent::insert($record);
        if ($rdo) {
            $this->setMsg(["msg" => "Video consulta creada con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se pudo crear la video consulta", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cambia el estado de una video consulta
     * 
     * @param type $request
     * @return boolean
     */

    public function cambiarEstado($request) {
        $videoconsulta = $this->get($request["idvideoconsulta"]);
        //verificamos que vengan los campos necesarios
        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No se ha seleccionado un estado"]);
            return false;
        }

        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] == "3" && $request["motivoRechazo_idmotivoRechazo"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione un motivo de rechazo"]);
            return false;
        }

        //si se finaliza o rechaza seteamos el horario de finalizacion
        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] == "3" || $request["estadoVideoConsulta_idestadoVideoConsulta"] == "4") {
            $request["fecha_fin"] = date("Y-m-d H:i:s");
        }

        //finalizacon pendiente cundo trancurre el tiempo de la VC
        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] == "8" && ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "7" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "8")) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo finalizar la consulta en curso"]);
            return false;
        }
        //si se finaliza  el horario de finalizacion
        if ($request["estadoVideoConsulta_idestadoVideoConsulta"] == "8") {

            $request["fecha_fin"] = date("Y-m-d H:i:s");
        }
        $rdo = parent::update($request, $request["idvideoconsulta"]);
        if ($rdo) {
            $client = new XSocketClient();

            $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

            $this->setMsg(["result" => true, "msg" => "Se ha cambiado el estado de la consulta"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se ha podido cambiar el estado de la consulta"]);
            return false;
        }
    }

    /*     * Metodo que cambia el estado a "En curso" y setea la hora de inicio cuando se acepta e inicia la llamada de videoconsulta
     * 
     */

    public function iniciarLlamada($idvideoconsulta) {

        $videoconsulta = $this->get($idvideoconsulta);
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ($videoconsulta["medico_idmedico"] != $idmedico) {

            //redirigir  a la home
            header('Location:' . URL_ROOT . "panel-medico/videoconsulta/");
            exit;
        }
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 7 && $videoconsulta["inicio_llamada"] != "" && $videoconsulta["fin_llamada"] != "") {


            /* FIX 13-08-2020:ya no se finaliza cuando inicia la proxima */
            //nos fijamos si hay una videoconsulta siguiente antes de que terminen los minutos por defecto de finalizacion de la VC actual
            /* $proxima_videoconsulta = $this->getSiguienteConsultaAbierta($idvideoconsulta);
              if ($proxima_videoconsulta["idvideoconsulta"] != "" && strtotime($videoconsulta["fin_llamada"]) > strtotime($proxima_videoconsulta["inicio_sala"])) {
              //seteamos como tiempo limite, el momento en que inicia la otra sala
              $record["fin_llamada"] = $proxima_videoconsulta["inicio_sala"];

              $rdo = parent::update($record, $idvideoconsulta);
              if ($rdo) {
              //seteamos los segundos restantes que le quedan a la llamada
              $tiempo_restante = strtotime($record["fin_llamada"]) - strtotime($record["inicio_llamada"]);
              $this->setMsg(["msg" => "La consulta ya se encuentra iniciada", "result" => true, "tiempo_restante" => $tiempo_restante]);
              return true;
              } else {
              $this->setMsg(["msg" => "No se ha podido establecer  el inicio de la videoconsulta", "result" => false]);
              return false;
              }
              } */

            //seteamos los segundos restantes que le quedan a la llamada
            $tiempo_restante = strtotime($videoconsulta["fin_llamada"]) - strtotime(date("Y-m-d H:i:s"));
            $this->setMsg(["msg" => "La consulta ya se encuentra iniciada", "result" => true, "tiempo_restante" => $tiempo_restante]);
            return true;
        } elseif ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 2) {


            $record["inicio_llamada"] = date("Y-m-d H:i:s");
            $record["fin_llamada"] = date("Y-m-d H:i:s", strtotime("+" . VIDEOCONSULTA_DURACION . " minutes", strtotime($record["inicio_llamada"])));


            /* FIX 13-08-2020:ya no se finaliza cuando inicia la proxima */
            //nos fijamos si hay una videoconsulta siguiente antes de que terminen los minutos por defecto de finalizacion de la VC actual

            /*
              $proxima_videoconsulta = $this->getSiguienteConsultaAbierta($idvideoconsulta);
              if ($proxima_videoconsulta["idvideoconsulta"] != "" && strtotime($record["fin_llamada"]) > strtotime($proxima_videoconsulta["inicio_sala"])) {
              //seteamos como tiempo limite, el momento en que inicia la otra sala
              $record["fin_llamada"] = $proxima_videoconsulta["inicio_sala"];
              } */

            $record["estadoVideoConsulta_idestadoVideoConsulta"] = 7; //llamada en curso
            $rdo = parent::update($record, $idvideoconsulta);
            if ($rdo) {
                //seteamos los segundos restantes que le quedan a la llamada
                $tiempo_restante = strtotime($record["fin_llamada"]) - strtotime($record["inicio_llamada"]);
                $this->setMsg(["msg" => "Se ha establecido el inicio de la videoconsulta", "result" => true, "tiempo_restante" => $tiempo_restante]);
                return true;
            } else {
                $this->setMsg(["msg" => "No se ha podido establecer  el inicio de la videoconsulta", "result" => false]);
                return false;
            }
        } else {
            $this->setMsg(["msg" => "La videoconsulta no se encuentra abierta", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cancela una video consulta en estado pendiente y  realiza la devolucion del dinero
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function cancelarVideoConsultaPendiente($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta", "result" => false]);
            return false;
        }
        if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "1" && $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "2") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado pendiente", "result" => false]);
            return false;
        }

        if ($consulta["tomada"] != "0") {
            $this->setMsg(["msg" => "La consulta está siendo respondida por un profesional", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $devolucion = $this->getManager("ManagerMovimientoCuenta")->processVencimientoVC(["idvideoconsulta" => $idvideoconsulta]);

        $delete = parent::update(["visualizar_consulta_paciente" => 0, "visualizar_consulta_medico" => 0, "estadoVideoConsulta_idestadoVideoConsulta" => 9], $idvideoconsulta);
        if ($devolucion && $delete) {

            if ($consulta["turno_idturno"] != "") {

                //Tengo que modificar el turno y enviar una notificación al médico
                $update_turno = array(
                    "estado" => 0, //pendiente
                    "comentario" => "",
                    "asistenciaPaciente" => "",
                    "anulado" => "",
                    "isEnvioRecordatorio" => 0,
                    "paciente_idpaciente" => "",
                    "fechaSolicitudTurno" => "",
                    "fechaReservaTurno" => "",
                    "fechaCambioEstado" => "",
                    "motivovisita_idmotivoVisita" => "",
                    "visitaPrevia" => 0,
                    "particular" => 0,
                    "obraSocial_idobraSocial" => "",
                    "planObraSocial_idplanObraSocial" => "",
                    "perfilSaludConsulta_idperfilSaludConsulta" => "",
                    "stripe_payment_intent_id" => "",
                    "stripe_payment_method" => "",
                    "pago_stripe" => 0,
                    "idprograma_categoria" => ""
                );

                //Envío la notificacion al paciente de cancelación
                $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                $record["idturno"] = $consulta["turno_idturno"];

                $notificacion = $ManagerNotificacion->createNotificacionFromCancelacionTurnoPaciente($record);
                if (!$notificacion) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo cancelar la video consulta", "result" => false]);
                    return false;
                }

                $update_trn = $this->getManager("ManagerTurno")->update($update_turno, $consulta["turno_idturno"]);
                if (!$update_trn) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo cancelar la video consulta", "result" => false]);
                    return false;
                }
            }

            if ($consulta["medico_idmedico"] != "") {
                $client = new XSocketClient();
                $client->emit("cambio_estado_videoconsulta_php", $consulta);

                //Enviamos mail al medico
                $this->enviarMailCancelacionConsulta($idvideoconsulta);

                //Enviamos sms al medico
                $this->enviarSMSCancelacionConsulta($idvideoconsulta);

                //Enviamos la notificacion al medico
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                $notify["text"] = "Demande de Vidéo Consultation annulée";
                $notify["type"] = "cancelar-vc";
                $notify["id"] = $consulta["idvideoconsulta"];
                $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                $notify["style"] = "video-consulta";
                $client->emit('notify_php', $notify);
            }
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha cancelado la Video Consulta. El importe de la misma ha sido devuelto a su cuenta", "result" => true]);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo cancelar la video consulta", "result" => false]);
            return false;
        }
    }

    /*     * Metodo donde el paciente cancela una video consulta en estado pendiente de finalizacion 
     * pasa a estado finalizado y se acredita el dinero del medico
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function cancelarVideoConsultaPendienteFinalizacionPaciente($idvideoconsulta) {


        $consulta = $this->get($idvideoconsulta);
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta", "result" => false]);
            return false;
        }
        if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "8") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado pendiente de finalización", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $record["estadoVideoConsulta_idestadoVideoConsulta"] = 4;
        $record["cancelada_paciente"] = 1;
        $record["leido_paciente"] = 0;
        $record["leido_medico"] = 0;

        $rdo = parent::update($record, $idvideoconsulta);
        $acreditar_medico = $this->getManager("ManagerMovimientoCuenta")->processFinalizacionVC(["idvideoconsulta" => $idvideoconsulta, "medico_idmedico" => $consulta["medico_idmedico"]]);

        if ($rdo && $acreditar_medico) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha cancelado la Video Consulta.",
                "result" => true]);
            $client = new XSocketClient();
            $client->emit("cambio_estado_videoconsulta_php", $consulta);

            //notify
            $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
            $notify["text"] = "Vidéo Consultation annulée";
            $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
            $notify["style"] = "video-consulta";
            $client->emit('notify_php', $notify);
            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo cancelar la video consulta",
                "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cancela una video consulta en estado pendiente y la republica cambiando la informacion
     *  tambien se realiza la devolucion del dinero
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function cancelarRepublicarVideoConsultaPendiente($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        if ($consulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la video consulta",
                "result" => false]);
            return false;
        }
        if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "1") {
            $this->setMsg(["msg" => "Error. La consulta no se encuentra en estado pendiente", "result" => false]);
            return false;
        }

        if ($consulta["tomada"] != "0") {
            $this->setMsg(["msg" => "La consulta está siendo respondida por un profesional", "result" => false]);
            return false;
        }
        $this->db->StartTrans();
        $devolucion = $this->getManager("ManagerMovimientoCuenta")->processVencimientoVC(["idvideoconsulta" => $idvideoconsulta]);
        $republicar = $this->republicar_from_vencidas_paciente(["id" => $idvideoconsulta]);

        if ($devolucion && $republicar) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Se ha cancelado la video consulta. El importe de la misma ha sido devuelto a su cuenta", "result" => true]);
            $client = new XSocketClient();
            $client->emit("cambio_estado_videoconsulta_php", $consulta);

            $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
            $notify["text"] = "Vidéo Consultation annulée";
            $notify["medico_idmedico"] = $consulta["medico_idmedico"];
            $notify["style"] = "video-consulta";
            $client->emit('notify_php', $notify);

            // <-- LOG
            $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
            $log["page"] = "Video Consultation";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Delete Video Consultation request SENT";

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // 


            return true;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "Error. No se pudo cancelar la video consulta", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que cambia el estado y realiza la devolucion del dinero o republica una videoconsulta en la red cuando 
     * trancurrio el tiempo de espera en el consultorio sin realizarse la llamada por parte del medico
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function process_vencimiento_espera_videoconsulta($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ($consulta["medico_idmedico"] != $idmedico) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar la videoconsulta", "result" => false]);
            return false;
        }
        if ($consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "2" && $consulta["estadoVideoConsulta_idestadoVideoConsulta"] != "7") {

            $this->setMsg(["msg" => "La consulta no se encuentra abierta", "result" => false]);
            return false;
        }



        $this->db->StartTrans();

        //si no es una consulta a profesionales en la red, la vencemos y devolvemos el dinero
        if ($consulta["tipo_consulta"] != 0) {



            $devolucion = $this->getManager("ManagerMovimientoCuenta")->processVencimientoVC(["idvideoconsulta" => $idvideoconsulta]);
            $upd = parent::update(["estadoVideoConsulta_idestadoVideoConsulta" => 5], $idvideoconsulta);


            if ($devolucion && $upd) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Se ha vencido la Video Consulta. El importe de la misma ha sido devuelto al paciente", "result" => true]);
                $client = new XSocketClient();
                $client->emit("cambio_estado_videoconsulta_php", $consulta);
                $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                $notify["text"] = "Vidéo Consultation expirée";
                $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
                $notify["style"] = "video-consulta";
                $notify["type"] = "vencimiento-vc";
                $notify["id"] = $consulta["idvideoconsulta"];
                $client->emit('notify_php', $notify);

                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo vencer la video consulta",
                    "result" => false]);
                return false;
            }
        } else {
            //si es una consulta a profesionales en la red, la volvemos a la bolsa
            $record["estadoVideoConsulta_idestadoVideoConsulta"] = 1;
            $record["tomada"] = 0;
            $record["medico_idmedico"] = "";
            $record["fecha_vencimineto_toma"] = "";
            $record["fecha_toma"] = "";
            $record["notificacion_ingreso_sala"] = 0;
            $record["inicio_sala"] = "";
            $record["inicio_llamada"] = "";
            $record["aceptar_en"] = "";
            $record["precio_tarifa"] = "";
            $upd = parent::update($record, $idvideoconsulta);

            if ($upd) {
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "La consulta se ha republicado a los presionales en la red", "result" => true]);
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg(["msg" => "Error. No se pudo republicar a los presionales en la red la video consulta", "result" => false]);
                return false;
            }
        }
    }

    /**
     * Método utilizado para extender la video consulta desde el paciente
     * @param type $request
     */
    public function republicar_from_vencidas_paciente($request) {

        $this->db->StartTrans();
        if ((int) $request["id"] > 0) {
            $videoconsulta = parent::get($request["id"]);

            $videoconsulta_borrador = $this->getVideoConsultaBorrador($videoconsulta["paciente_idpaciente"]);
            if ($videoconsulta_borrador) {
                //Se elimina la consulta que está en borrador
                $delete = parent::delete($videoconsulta_borrador[$this->id]);
                if (!$delete) {
                    $this->setMsg(["msg" => "Error, no se pudo republicar la Video Consulta", "result" => false
                    ]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //Elimino la consulta from vencidas
            $eliminar_from_vencidas = $this->eliminar_from_vencidas_paciente($request);
            if (!$eliminar_from_vencidas) {
                $this->setMsg(["msg" => "Error, no se pudo republicar la Video Consulta", "result" => false
                ]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }


            /**
             * Creo el insert de la video consulta
             */
            $insert = [
                "paciente_idpaciente" => $videoconsulta["paciente_idpaciente"],
                "estadoVideoConsulta_idestadoVideoConsulta" => 6,
                "consulta_step" => 0,
                "motivoVideoConsulta_idmotivoVideoConsulta" => $videoconsulta["motivoVideoConsulta_idmotivoVideoConsulta"],
                "tipo_consulta" => $videoconsulta["tipo_consulta"],
                "republicacion" => $videoconsulta["numeroVideoConsulta"]
            ];

            $insert_vc = parent::insert($insert);
            $record["numeroVideoConsulta"] = STR_PAD($insert_vc, 7, "0", STR_PAD_LEFT);

            $upd = parent::update($record, $insert_vc);

            if ($upd) {

                //Clonado de mensajes
                $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
                $primer_mensaje = $ManagerMensajeVideoConsulta->getPrimerMensaje($request["id"]);
                if ($primer_mensaje) {
                    $rdo_clone = $ManagerMensajeVideoConsulta->cloneMensaje($primer_mensaje["idmensajeVideoConsulta"], $insert_vc);


                    if (!$rdo_clone) {
                        $this->setMsg(["msg" => "Error, no se pudo republicar la consulta", "result" => false
                        ]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }



                // <-- LOG
                $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
                $log["page"] = "Video Consultation";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Republicate Video Consultation request EXPIRED";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 

                $this->setMsg(["msg" => "La consulta fue republicada con éxito. ", "result" => true
                ]);

                $this->db->CompleteTrans();
                $client = new XSocketClient();
                $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);
                return true;
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo republicar la consulta", "result" => false]);
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        return false;
    }

    /**
     * Método utilizado para republicar la video consulta desde el prestador a otro profesional
     * @param type $request
     */
    public function republicar_from_vencidas_prestador($request) {

        $this->db->StartTrans();
        if ((int) $request["id"] > 0) {

            $videoconsulta = parent::get($request["id"]);
            $request["motivoVideoConsulta_idmotivoVideoConsulta"] = $videoconsulta["motivoVideoConsulta_idmotivoVideoConsulta"];
            $request["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
            $request["republicacion"] = $videoconsulta["numeroVideoConsulta"];

            //Clonado de mensajes
            $ManagerMensajeVideoConsulta = $this->getManager("ManagerMensajeVideoConsulta");
            $primer_mensaje = $ManagerMensajeVideoConsulta->getPrimerMensaje($request["id"]);
            $request["mensaje"] = $primer_mensaje["mensaje"];

            $videoconsulta_borrador = $this->getVideoConsultaBorrador($videoconsulta["paciente_idpaciente"]);

            if ($videoconsulta_borrador) {
                //Se elimina la consulta que está en borrador
                $delete = parent::delete($videoconsulta_borrador[$this->id]);
                if (!$delete) {
                    $this->setMsg(["msg" => "Error, no se pudo republicar la Video Consulta", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //Elimino la consulta from vencidas
            $eliminar_from_vencidas = $this->eliminar_from_vencidas_paciente($request);
            if (!$eliminar_from_vencidas) {
                $this->setMsg(["msg" => "Error, no se pudo republicar la Video Consulta", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            /**
             * Creo la video consulta
             */
            $insert_vc = $this->crearVideoConsultaFromPrestador($request);
            if ($insert_vc) {
                $this->setMsg(["msg" => "La Video Consulta ha sido republicada con éxito", "result" => true]);

                $this->db->CompleteTrans();
                return true;
            } else {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo recuperar la Video Consulta a republicar", "result" => false]);
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        return false;
    }

    /**
     * Eliminación de las videoconsultas vencidas del listado
     * se marcará el flag "visualizar_consulta_medico"
     * @param type $request
     */
    public function eliminar_from_vencidas($request) {
        if ((int) $request["id"] > 0) {
            $videoconsulta = $this->get($request["id"]);
            if ($videoconsulta && $videoconsulta["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {
                $update = parent::update(["visualizar_consulta_medico" => 0], $videoconsulta[$this->id]);

                if ($update) {
                    $this->setMsg(["msg" => "Videoconsulta eliminada con éxito", "result" => true]);
                    return $update;
                }
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo eliminar la video consulta", "result" => false]);
        return false;
    }

    /**
     * Eliminación de las videoconsultas vencidas del listado
     * se marcará el flag "visualizar_consulta_paciente"
     * @param type $request
     */
    public function eliminar_from_vencidas_paciente($request) {

        if ((int) $request["id"] > 0) {
            $videoconsulta = $this->get($request["id"]);
            if ($videoconsulta) {
                $update = parent::update(["visualizar_consulta_paciente" => 0], $videoconsulta[$this->id]);

                if ($update) {
                    $this->setMsg(["msg" => "Videoconsulta eliminada con éxito", "result" => true]);


                    // <-- LOG
                    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
                    $log["page"] = "Video Consultation";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Delete Video Consultation request EXPIRED";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 
                    return $update;
                }
            }
        }

        $this->setMsg(["msg" => "Error, no se pudo eliminar la video consulta", "result" => false]);
        return false;
    }

    /**
     * Método utilizado para extender la video consulta desde el paciente
     * @param type $request
     */
    public function extender_from_vencidas_paciente($request) {


        if ((int) $request["id"] > 0) {

            $consulta = $this->get($request["id"]);
            $ahora = date("Y-m-d H:i:s");

            //Extiendo el plazo del tiempo...
            $update = array(
                "estadoVideoConsulta_idestadoVideoConsulta" => 6, //borrador
                "fecha_inicio" => $ahora,
                "consulta_step" => 4,
                "fecha_fin" => "",
                "visualizaciones" => 0,
                "leido_paciente" => 0,
                "leido_medico" => 0,
                "recordatorio_inicio_sala" => "",
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
                $update["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_VC_RED . " hour", strtotime($ahora));
            } else {
                //Profesionales frecuentes
                $update["fecha_vencimiento"] = strtotime("+" . VENCIMIENTO_VC_FRECUENTES . " hour", strtotime($ahora));
            }
            //actualizamos la consulta
            $this->db->StartTrans();
            $update_vc = parent::update($update, $request["id"]);
            if ($update_vc) {

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
     * Método utilizado para extender la consulta express desde el paciente
     * @param type $request
     */
    public function extender_from_vencidas_prestador($request) {

        if ((int) $request["id"] > 0) {

            $consulta = $this->get($request["id"]);
            $ahora = date("Y-m-d H:i:s");

            //Extiendo el plazo del tiempo...
            $update = array(
                "estadoVideoConsulta_idestadoVideoConsulta" => 1, //Pendiente
                "fecha_inicio" => $ahora,
                "fecha_fin" => "",
                "visualizaciones" => 0,
                "leido_paciente" => 0,
                "leido_medico" => 0,
                "visualizar_consulta_paciente" => 1,
                "visualizar_consulta_medico" => 1
            );

            //Fechas de vencimiento
            if ($consulta["tipo_consulta"] == "0") {
                //Profesionales en la red
                $update["fecha_vencimiento"] = strtotime('+1 hour', strtotime($ahora));
            } else {
                //Profesionales frecuentes
                $update["fecha_vencimiento"] = strtotime('+2 hour', strtotime($ahora));
            }
            //actualizamos la consulta
            $this->db->StartTrans();
            $update_vc = parent::update($update, $request["id"]);


            if ($update_vc) {

                //descontamos el dinero de la consulta para republicarla
                if ($consulta["tipo_consulta"] == "0") {
                    //Profesionales en la red, es el rango máximo de filtro
                    $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $consulta["idvideoconsulta"]);
                    $recordMovimiento["rango_maximo"] = $filtro["rango_maximo"];
                }

                $recordMovimiento["idvideoconsulta"] = $request["id"];
                $recordMovimiento["paciente_idpaciente"] = $consulta["paciente_idpaciente"];


                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionVC($recordMovimiento);
                //fin procesamiento decontar dinero


                if ($movimiento_cuenta) {
                    $client = new XSocketClient();
                    //enviamos el mail al medico si esta dirgida a un profesional
                    if ($consulta["medico_idmedico"] != "" && $consulta["tipo_consulta"] == "1") {
                        $this->enviarMailNuevaVC($consulta["idvideoconsulta"]);
                        $this->enviarSMSNuevaVC($consulta["idvideoconsulta"]);

                        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                        $notify["text"] = "Nouvelle demande en Visio ";
                        $notify["type"] = "nueva-vc";
                        $notify["id"] = $request["idvideoconsulta"];
                        $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                        $notify["style"] = "video-consulta";
                        $client->emit('notify_php', $notify);
                    }
                    $this->actualizarEstados();
                    $this->setMsg(["msg" => "Se extendió el plazo de la consulta", "result" => true]);

                    $this->db->CompleteTrans();

                    $client->emit("cambio_estado_videoconsulta_php", $consulta);

                    if ($consulta["tipo_consulta"] == "0") {
                        $client->emit('cambio_estado_videoconsulta_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                    }




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

    /*     * Metodo que acepta la videoconsulta por parte del medico e inicia la sala
     * opcion= 1:se inicia la sala en ese momento
     * opcion= 2:se inicia la sala dentro de 5 min
     * opcion= 3:se inicia la sala dentro de 10 min
     * opcion= 4:se inicia la sala dentro de 15 min
     * opcion= 5:se inicia la sala dentro de 30 min
     * opcion= 6:se inicia la sala dentro de 60 min
     * @param type $request
     * @return boolean
     */

    public function aceptarVideoConsulta($request) {

        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        if ((int) $request["idvideoconsulta"] > 0 && $request["inicio"] != "") {
            $videoconsulta = $this->get($request["idvideoconsulta"]);
            if ($videoconsulta) {


                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $videoconsulta["medico_idmedico"] || ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 1 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 8 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 7)) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la video consulta seleccionada",
                        "result" => false
                    ]);

                    return false;
                }

                if ($request["inicio"] == "0") {//Aceptar ahora mismo
                    //verificamos si tiene una consulta ahora
                    $idproxima_videoconsulta = $this->getProximaVideoConsulta();
                    if ((int) $idproxima_videoconsulta > 0 && (int) $idproxima_videoconsulta != (int) $request["idvideoconsulta"]) {
                        $proxima_videoconsulta = $this->get($idproxima_videoconsulta);

                        $segundos_inicio_proxima = strtotime($proxima_videoconsulta["inicio_sala"]) - strtotime(date("Y-m-d H:i:s"));
                        //verificamos si tiene una consulta en los proximos 10min
                        if ($segundos_inicio_proxima < 900) {


                            $min = (int) $segundos_inicio_proxima / 60;
                            $min = substr($min, 0, strpos($min, "."));
                            if ($min > 0) {
                                $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera en los próximos [[$min]] min", "result" => false]);
                            } else {
                                $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera actualmente", "result" => false]);
                            }


                            return false;
                        }
                    }
                    $record["inicio_sala"] = date("Y-m-d H:i:s");
                    $record["aceptar_en"] = 0;
                    $msg_notify = "Le professionnel vous attend actuellement dans la salle!";
                } else {// Aceptar consulta en una fecha determinada
                    //verificamos que no haya una consulta en ese horario
                    $sala_disponible = $this->verificarInicioSalaDisponible($request);
                    if (!$sala_disponible) {
                        $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera actualmente", "result" => false]);
                        return false;
                    }
                    /* Verificamos horario en el pasado */
                    if (strtotime($request["inicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                        $this->setMsg(["msg" => "Error. El inicio de la videoconsulta debe ser una fecha futura", "result" => false]);
                        return false;
                    }
                    $record["inicio_sala"] = $request["inicio"];
                    $record["aceptar_en"] = $request["inicio"];


                    $dia_numero = date('d', strtotime($request["inicio"]));
                    if ($dia_numero != date("d", time())) {
                        $dia_nombre = getNombreCortoDia(date('N', strtotime($request["inicio"])));

                        $msg_notify = "Le professionnel vous attendra  dans la salle le {$dia_nombre} {$dia_numero} à " . date('H:i', strtotime($request["inicio"])) . "hs.";
                    } else {
                        $msg_notify = "Le professionnel vous attendra  dans la salle aujourd'hui à " . date('H:i', strtotime($request["inicio"])) . "hs.";
                    }
                }




                $record["estadoVideoConsulta_idestadoVideoConsulta"] = 2;
                $record["leido_medico"] = 0;
                $record["notificacion_ingreso_sala"] = 0;
                //acciones cuando se acepta una consulta que esta penditente de finalizacion
                $registro = true;
                if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 8) {

                    $record["reapertura_sala"] = 1;
                    //insertamos la fecha y hora del comienzo de la videoconsulta cuando el medico la acepta nuevamente de las pendientes de finalizacion
                    $registro_llamada["inicio_sala"] = $record["inicio_sala"];
                    $registro_llamada["videoconsulta_idvideoconsulta"] = $request["idvideoconsulta"];
                    $registro = $this->getManager("ManagerRegistroInicioSala")->insert($registro_llamada);
                }
                $this->db->StartTrans();
                $mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $videoconsulta["paciente_idpaciente"]]);

                $upd = parent::update($record, $request["idvideoconsulta"]);

                $create_session = $this->getManager("ManagerVideoConsultaSession")->iniciar_sesion_open_tok($request["idvideoconsulta"]);
                if (!$create_session) {
                    $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.",
                        "result" => false
                    ]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                }

                $vc = $this->get($request["idvideoconsulta"]);
                $rec = $this->getManager("ManagerGanadoresRecompensa")->getRecoByIdpaci($vc["paciente_idpaciente"]);

                //Me fijo si se esta aceptando la consulta, si la consulta pertenece a la red y si no es de un prestador
                if ($videoconsulta["tipo_consulta"] == "0" && $videoconsulta["prestador_idprestador"] == "" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == "1") {
                    $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                    //si es paciente empresa y se debito consulta del plan empresa no hay que procesar diferencia de dinero
                    if (($paciente["is_paciente_empresa"] == 1 && $videoconsulta["debito_plan_empresa"] == 1) || ($rec != '')) {
                        $procesar_diferencia = false;
                    } else {
                        //Process movimiento de diferencia  entre lo que cobra el medico y lo que se desconto al paciente
                        $procesar_diferencia = true;
                    }
                }
                if ($procesar_diferencia) {
                    $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                    $rdo1 = $ManagerMovimientoCuenta->processDiferenciaPublicacionVC($videoconsulta);

                    if (!$rdo1) {
                        $this->setMsg($ManagerMovimientoCuenta->getMsg());
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }

                if ($upd && $registro && $mis_pacientes) {
                    $this->enviarMailAceptarVC($request["idvideoconsulta"]);
                    $this->enviarSMSAceptarVC($request["idvideoconsulta"]);

                    // <-- LOG
                    $log["data"] = "date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
                    $log["page"] = "Video Consultation";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Accept Video Consultation request RECEIVED";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);

                    //realizamos el cobro en stripe -
                    //cobrar al consultas particulares (en la red se cobra en la devolucion de diferencia)
                    if (CONTROLLER == "medico" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == "1" && $videoconsulta["pago_stripe"] == "1") {
                        $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                        $confirmar_cobro = $ManagerCustomerStripe->confirmar_cobro_consulta($request["idvideoconsulta"], "videoconsulta");
                        if (!$confirmar_cobro) {
                            $this->setMsg($ManagerCustomerStripe->getMsg());
                            $this->db->FailTrans();
                            return false;
                        }
                    }

                    $this->setMsg(["msg" => "Se ha aceptado la videoconsulta con éxito",
                        "result" => true
                    ]);
                    $this->db->CompleteTrans();
                    $client = new XSocketClient();
                    $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                    $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                    $notify["text"] = $msg_notify;
                    $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                    $notify["style"] = "video-consulta";
                    $notify["type"] = "vc_aceptada";
                    $notify["id"] = $request["idvideoconsulta"];
                    $client->emit('notify_php', $notify);




                    if ($videoconsulta["tipo_consulta"] == "0") {
                        $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $videoconsulta["idvideoconsulta"]);
                        $client->emit('cambio_estado_videoconsulta_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                    }
                    return true;
                } else {
                    $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
        } else {
            //Error no hay videoconsulta
            $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);

            return false;
        }
    }

    /*     * Metodo que acepta la videoconsulta por parte del medico e inicia la sala
     * opcion= 1:se inicia la sala en ese momento
     * opcion= 2:se inicia la sala dentro de 5 min
     * opcion= 3:se inicia la sala dentro de 10 min
     * opcion= 4:se inicia la sala dentro de 15 min
     * opcion= 5:se inicia la sala dentro de 30 min
     * opcion= 6:se inicia la sala dentro de 60 min
     * @param type $request
     * @return boolean
     */

    public function posponerVideoConsulta($request) {

        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ((int) $request["idvideoconsulta"] > 0 && $request["inicio"] != "") {
            $videoconsulta = $this->get($request["idvideoconsulta"]);
            if ($videoconsulta) {


                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $videoconsulta["medico_idmedico"] || ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 2 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 7 )) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la video consulta seleccionada",
                        "result" => false
                    ]);

                    return false;
                }
                if ($request["inicio"] == "0") {//Aceptar ahora mismo
                    //verificamos si tiene una consulta ahora
                    $idproxima_videoconsulta = $this->getProximaVideoConsulta();
                    if ((int) $idproxima_videoconsulta > 0 && (int) $idproxima_videoconsulta != (int) $request["idvideoconsulta"]) {
                        $proxima_videoconsulta = $this->get($idproxima_videoconsulta);

                        $segundos_inicio_proxima = strtotime($proxima_videoconsulta["inicio_sala"]) - strtotime(date("Y-m-d H:i:s"));

                        if ($segundos_inicio_proxima < 900) {


                            $min = (int) $segundos_inicio_proxima / 60;
                            $min = substr($min, 0, strpos($min, "."));
                            if ($min > 0) {
                                $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera en los próximos  [[$min]] min", "result" => false]);
                            } else {
                                $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera actualmente", "result" => false]);
                            }


                            return false;
                        }
                    }
                    $record["inicio_sala"] = date("Y-m-d H:i:s");
                    $record["aceptar_en"] = 0;
                    $msg_notify = "Le professionnel vous attend actuellement dans la salle!";
                } else {// Aceptar consulta en una fecha determinada
                    //verificamos que no haya una consulta en ese horario
                    $sala_disponible = $this->verificarInicioSalaDisponible($request);
                    if (!$sala_disponible) {
                        $this->setMsg(["msg" => "Ud. posee actualmente una Video Consulta en espera actualmente", "result" => false]);
                        return false;
                    }
                    /* Verificamos horario en el pasado */
                    if (strtotime($request["inicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                        $this->setMsg(["msg" => "Error. El inicio de la videoconsulta debe ser una fecha futura", "result" => false]);
                        return false;
                    }
                    $record["inicio_sala"] = $request["inicio"];
                    $record["aceptar_en"] = $request["inicio"];
                    $dia_numero = date('d', strtotime($request["inicio"]));
                    if ($dia_numero != date("d", time())) {
                        $dia_nombre = getNombreCortoDia(date('N', strtotime($request["inicio"])));

                        $msg_notify = "Le professionnel vous attendra  dans la salle le {$dia_nombre} {$dia_numero} à " . date('H:i', strtotime($request["inicio"])) . "hs.";
                    } else {
                        $msg_notify = "Le professionnel vous attendra  dans la salle aujourd'hui à " . date('H:i', strtotime($request["inicio"])) . "hs.";
                    }
                }
                $record["estadoVideoConsulta_idestadoVideoConsulta"] = 2;
                $record["leido_medico"] = 0;
                $record["notificacion_ingreso_sala"] = 0;
                $record["recordatorio_inicio_sala"] = "";
                //acciones cuando se acepta una consulta que esta penditente de finalizacion
                $registro = true;
                if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 8) {

                    $record["reapertura_sala"] = 1;
                    //insertamos la fecha y hora del comienzo de la videoconsulta cuando el medico la acepta nuevamente de las pendientes de finalizacion
                    $registro_llamada["inicio_sala"] = $record["inicio_sala"];
                    $registro_llamada["videoconsulta_idvideoconsulta"] = $request["idvideoconsulta"];
                    $registro = $this->getManager("ManagerRegistroInicioSala")->insert($registro_llamada);
                }
                $this->db->StartTrans();
                $mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $videoconsulta["paciente_idpaciente"]]);

                $upd = parent::update($record, $request["idvideoconsulta"]);

                $create_session = $this->getManager("ManagerVideoConsultaSession")->iniciar_sesion_open_tok($request["idvideoconsulta"]);
                if (!$create_session) {
                    $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.",
                        "result" => false
                    ]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                }
                if ($upd && $registro && $mis_pacientes) {
                    $this->enviarMailPosponerVC($request["idvideoconsulta"]);
                    $this->enviarSMSPosponerVC($request["idvideoconsulta"]);
                    $this->setMsg(["msg" => "Se ha actualizado la videoconsulta con éxito",
                        "result" => true
                    ]);
                    $this->db->CompleteTrans();
                    $client = new XSocketClient();
                    $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                    $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                    $notify["text"] = $msg_notify;
                    $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                    $notify["style"] = "video-consulta";
                    $client->emit('notify_php', $notify);




                    if ($videoconsulta["tipo_consulta"] == "0") {
                        $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $videoconsulta["idvideoconsulta"]);
                        $client->emit('cambio_estado_videoconsulta_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                    }
                    return true;
                } else {
                    $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
        } else {
            //Error no hay videoconsulta
            $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);

            return false;
        }
    }

    /*     * Metodo que verifica el estado y la disponibilidad de la videoconsulta al acceder al consultorio virtual 
     * verificando si no han pasado los minutos de espera
     * 
     * @param type $idvideoconsulta
     */

    public function acceder_consultorio_virtual($idvideoconsulta) {


        // $idproxima = $this->getProximaVideoConsulta();
        $videoconsulta = parent::get($idvideoconsulta);

        if (CONTROLLER == "medico") {

            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ($videoconsulta["medico_idmedico"] != $idmedico) {
                //El videoconsulta no esta disponible
                $this->setMsg(["msg" => "Acceso al consultorio virtual no habilitado.", "result" => false]);

                return false;
            }
        }

        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ($videoconsulta["paciente_idpaciente"] != $paciente["idpaciente"]) {
                //El videoconsulta no esta disponible
                $this->setMsg(["msg" => "Acceso al consultorio virtual no habilitado.", "result" => false]);

                return false;
            }
        }
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 7 ||
                $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 2 ||
                ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 1 && $videoconsulta["tipo_consulta"] == 0 && $videoconsulta["tomada"] == 1)) {
            $this->setMsg(["msg" => "Acceso al consultorio virtual", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Acceso al consultorio virtual no habilitado.", "result" => false]);
            return false;
        }
    }

    /** Metodo que realiza la toma de la videoconsulta publicada en la red
     * 
     * @param type $request
     */
    public function tomarVideoConsulta($request) {
        $idvideoconsulta = $request["idvideoconsulta"];
        $videoconsulta = parent::get($idvideoconsulta);
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        if ($videoconsulta["idvideoconsulta"] == "") {

            $this->setMsg(["msg" => "Error. No se pudo recuperar la consulta", "result" => false]);
            return false;
        }
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == "2") {

            $this->setMsg(["msg" => "La consulta ya ha sido tomada por otro profesional", "result" => false, "abierta" => 1]);
            return false;
        }
        $this->db->StartTrans();
        if ($videoconsulta["tomada"] == 1) {
            $fecha_actual = strtotime(date("Y-m-d H:i:s"));
            $fecha_vencimiento_toma = strtotime($videoconsulta["fecha_vencimiento_toma"]);

            //si ya vencio la toma la actualizamos
            if ($fecha_actual > $fecha_vencimiento_toma) {
                $vencimiento = date_create($videoconsulta["fecha_vencimiento"]);
                $fecha_toma = date_create($videoconsulta["fecha_toma"]);
                $intervalo = date_diff($vencimiento, $fecha_toma);

                $add_mins = $intervalo->format('%i');
                $add_sec = $intervalo->format('%s');

                $record["fecha_vencimiento"] = strtotime('+' . $add_mins . 'minutes ' . $add_sec . ' seconds', strtotime(date("Y-m-d H:i:s")));

                $rdo1 = parent::update($record, $idvideoconsulta);

                if (!$rdo1) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                }
            } else {//sino retornamos el medio que la tomo
                $ManagerMedico = $this->getManager("ManagerMedico");
                $medico_tomada = $ManagerMedico->get($videoconsulta["medico_idmedico"], true);
                $medico_tomada["imagen"] = $ManagerMedico->getImagenMedico($videoconsulta["medico_idmedico"]);
                $medico_tomada["segundos_diferencia_toma"] = $fecha_vencimiento_toma - $fecha_actual;






                $this->setMsg(["msg" => "La consulta ya ha sido tomada", "result" => true, "tomada" => 1, "medico_tomada" => $medico_tomada]);
                return false;
            }
        }



        $record["tomada"] = 1;
        $record["fecha_toma"] = date("Y-m-d H:i:s");

        $fecha_actual = strtotime(date("Y-m-d H:i:s"));
        $fecha_vencimiento = strtotime($videoconsulta["fecha_vencimiento"]);

        if ($fecha_actual > $fecha_vencimiento) {
            $this->setMsg(["msg" => "Error. Ya pasó el período de publicación de la videoconsulta", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
        //seteamos el vencimiento de la toma de videoconsulta como el inicio de la sala +5 min

        $record["fecha_vencimiento_toma"] = date('Y-m-d H:i:s', strtotime("+10 minute"));
        $record["medico_idmedico"] = $idmedico;
        $record["leido_medico"] = 0;


        //seteamos el costo si no es del prestador
        if ($videoconsulta["prestador_idprestador"] == "") {
            $medico = $this->getManager("ManagerMedico")->get($idmedico);
            $preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);
            $record["precio_tarifa"] = $preferencia["valorPinesVideoConsulta"];

            if ($record["precio_tarifa"] == "") {
                $this->setMsg(["msg" => "Error. No se pudo tomar la videoconsulta", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }

        $rdo = parent::update($record, $idvideoconsulta);


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

    /**
     * Método que obtiene la información de las video consultas pertenecientes a un determinado período y a un médico
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */
    public function getInfoVideoConsultaPeriodo($fecha_inicio, $fecha_fin, $idmedico) {

        $query = new AbstractSql();

        $query->setSelect("COUNT(idvideoconsulta) as cantidad_videoconsulta, SUM(IFNULL(precio_tarifa,0)) as monto_tarifa,SUM(IFNULL(comision_doctor_plus,0))+SUM(IFNULL(comision_prestador,0)) as monto_comision_doctor_plus");

        $query->setFrom("$this->table");

        $query->setWhere("fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin'");

        $query->addAnd("medico_idmedico = $idmedico");

        $query->addAnd("estadoVideoConsulta_idestadoVideoConsulta = 4");


        $row = $this->db->GetRow($query->getSql());

        return $row;
    }

    /*     * Metodo que setea el flag acreditado en las video consultas del periodo que han finalizado y se acreditan en la cuenta medico
     * @param type $fecha_inicio
     * @param type $fecha_fin
     * @param type $idmedico
     * @return type
     */

    public function acreditarVideoConsultaFinalizadaPeriodo($fecha_inicio, $fecha_fin, $idmedico) {
        return $this->db->Execute("update $this->table set acreditada=1 where estadoVideoConsulta_idestadoVideoConsulta = 4 AND acreditada=0 "
                        . " AND fecha_fin BETWEEN '$fecha_inicio' AND '$fecha_fin' AND medico_idmedico = $idmedico");
    }

    /**
     * Metodo que cambia el estado de la videoconsulta (estado=8) cuando termina la llamada el medico
     * y deja pendiente el cierre de la consulta medica
     */
    public function terminarVideoConsulta($idvideoconsulta) {
        if ((int) $idvideoconsulta > 0) {
            $videoconsulta = $this->get($idvideoconsulta);
            if ($videoconsulta) {

                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $videoconsulta["medico_idmedico"] || ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 7 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 8)) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la videoconsulta seleccionada", "result" => false]);

                    return false;
                }
                $rdo = $this->cambiarEstado(["idvideoconsulta" => $idvideoconsulta, "estadoVideoConsulta_idestadoVideoConsulta" => 8]);
                //inicializamos el paciente en sesion del medico para acceder al perfil de salud y cierre de videoconsulta
                $ManagerMedico = $this->getManager("ManagerMedico");
                $rdo1 = $ManagerMedico->inicializarPacienteFromMedico($videoconsulta["paciente_idpaciente"]);

                //en el resultado de la inicializacion tenemos los datos del pacientes
                $paciente = $ManagerMedico->getMsg();
                if ($rdo && $rdo1) {
                    $this->setMsg(["msg" => "La videoconsulta ha sido terminada. Debe escribir las conclusiones y finalizar la misma", "result" => true, "idpaciente" => str2seo($paciente["idpaciente"]), "nombre" => str2seo($paciente["nombre"]), "apellido" => str2seo($paciente["apellido"])]);

                    $client = new XSocketClient();
                    $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                    return true;
                } else {
                    $this->setMsg(["msg" => "Error. No se pudo finalizar la videoconsulta", "result" => false]);

                    return false;
                }
            }
        }
        //Error no hay videoconsulta
        $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);

        return false;
    }

    /**
     * Finalización de la videoconsulta, 
     * La finalización de la videoconsulta, se hará cuando el médico cierre la consulta medica creada al paciente.. 
     * DP, le deberá pagar al médico el dinero correspondiente
     * @param type $request
     */
    public function finalizarVideoConsulta($request) {

        if ((int) $request["idvideoconsulta"] > 0) {
            $videoconsulta = $this->get($request["idvideoconsulta"]);
            if ($videoconsulta) {

                $this->db->StartTrans();

                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

                //Si el médico de la consulta no corresponde a la consulta O el estado 
                if ($idmedico != $videoconsulta["medico_idmedico"] || $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 4) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la videoconsulta seleccionada", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }

                //DoctorPlus retendrá el dinero perteneciente a DP por su comision


                $medico = $this->getManager("ManagerMedico")->get($idmedico);
                $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                if ($videoconsulta["prestador_idprestador"] != "") {
                    $prestador = $this->getManager("ManagerPrestador")->get($videoconsulta["prestador_idprestador"]);
                    if ($prestador["comision_dp"] != "") {
                        $comision_doctor_plus = $videoconsulta["precio_tarifa_prestador"] * $prestador["comision_dp"] / 100;
                    } else {
                        $comision_doctor_plus = 0;
                    }

                    $update_videoconsulta = parent::update([
                                "comision_doctor_plus" => $comision_doctor_plus
                                    ], $videoconsulta[$this->id]);
                    if (!$update_videoconsulta) {
                        $this->setMsg(["msg" => "Error. No se pudo actualizar la video consulta", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();

                        return false;
                    }
                } else {
                    //Le tengo que agregar el monto a DP si la cuenta del médico es gratuita
                    if ($medico && (int) $medico["planProfesional"] == 0) {

                        //si el paciente es ALD no le retenemos

                        if ($videoconsulta["beneficia_reintegro"] != 1 || $videoconsulta["grilla_idgrilla"] == "" || $paciente["beneficia_ald"] != 1) {

                            //Le tengo que sacar la comision
                            $comision_doctor_plus = $videoconsulta["precio_tarifa"] * COMISION_VC / 100;
                            $update_videoconsulta = parent::update([
                                        "comision_doctor_plus" => $comision_doctor_plus
                                            ], $videoconsulta[$this->id]);
                            if (!$update_videoconsulta) {
                                $this->setMsg(["msg" => "Error. No se pudo actualizar la video consulta", "result" => false]);
                                $this->db->FailTrans();
                                $this->db->CompleteTrans();

                                return false;
                            }
                        }
                    }
                }





                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $finalizacion_cuenta = $ManagerMovimientoCuenta->processFinalizacionVC($videoconsulta);
                $this->getManager("ManagerPerfilSaludEstudios")->processFromVideoConsulta($videoconsulta["idvideoconsulta"]);

                if ($finalizacion_cuenta) {

                    //MOdifico el estado a finalizado
                    $this->setMsg(["msg" => "La Video Consulta fue finalizada con éxito", "result" => true]);

                    $this->db->CompleteTrans();


                    return $videoconsulta[$this->id];
                } else {

                    //MOdifico el estado a finalizado
                    $this->setMsg(["msg" => "La Video Consulta no pudo ser finalizada", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();

                    //Retorno el mensaje de error del manager de movimiento cuenta,
                    $this->setMsg($ManagerMovimientoCuenta->getMsg());
                    return false;
                }
            }
        }
        //Error no hay videoconsulta
        $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);

        return false;
    }

    /*     * Metodo mediante el cual el medico cancela una consulta pediente de finalizacion  y devuelve el dinero al paciente
     * La videoconsulta pasa el
     * 
     * @param type $request
     * @return boolean
     */

    public function devolverDinero($request) {

        if ((int) $request["idvideoconsulta"] > 0) {
            $videoconsulta = $this->get($request["idvideoconsulta"]);

            if ($videoconsulta) {



                $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
                //Si el médico de la consulta no corresponde a la consulta O el estado pendiente de finalizacion o en curso
                if ($idmedico != $videoconsulta["medico_idmedico"] || $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 5) {
                    $this->setMsg(["msg" => "La consulta ya se encuentra vencida",
                        "result" => false
                    ]);

                    return false;
                }

                //Si el médico de la consulta no corresponde a la consulta O el estado pendiente de finalizacion o en curso
                if ($idmedico != $videoconsulta["medico_idmedico"] || ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 8 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 2 && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != 7)) {
                    $this->setMsg(["msg" => "Error. Se produjo un error en la videoconsulta seleccionada", "result" => false]);

                    return false;
                }



                $this->db->StartTrans();
                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");


                $res = $ManagerMovimientoCuenta->processVencimientoVC(["idvideoconsulta" => $videoconsulta["idvideoconsulta"]]);
                //actualizamos el estado de la consulta
                $record["leido_medico"] = 0;
                $record["leido_paciente"] = 0;
                $record["estadoVideoConsulta_idestadoVideoConsulta"] = 5;
                $rdo = parent::update($record, $videoconsulta["idvideoconsulta"]);
                //devolvemos el dinero a los pacientes

                if (!$res || !$rdo) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return;
                } else {
                    $this->db->CompleteTrans();
                    $this->enviarMailReembolsoVC($videoconsulta["idvideoconsulta"]);
                    $this->enviarSMSReembolsoVC($videoconsulta["idvideoconsulta"]);
                    $this->setMsg(["msg" => "La videoconsulta ha sido reembolsada al paciente éxito", "result" => true]);
                    $client = new XSocketClient();
                    $client->emit("cambio_estado_videoconsulta_php", $videoconsulta);

                    $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                    $notify["text"] = "Votre Vidéo Consultation a été remboursée";
                    $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                    $notify["style"] = "video-consulta";
                    $notify["type"] = "vencimiento-vc";
                    $notify["id"] = $videoconsulta["idvideoconsulta"];
                    $client->emit('notify_php', $notify);

                    // <-- LOG
                    $log["data"] = "Confirmation to reimburse patient";
                    $log["page"] = "Video Consultation";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Reimburse Video Consultation";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 

                    return true;
                }
            }
        }
        //Error no hay videoconsulta
        $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.", "result" => false]);

        return false;
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando se finaliza la VC
     * @return boolean
     */
    public function enviarSMSFinalizacionVC($idvideoconsulta) {
        $videoconsulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($videoconsulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);

        $idperfilsaludconsulta = $this->getIdConclusion($idvideoconsulta);
        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);


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

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a rédigé votre compte-rendu: " .
                URL_ROOT . "patient/profil-de-sante/consultations-realisees-detail/{$idperfilsaludconsulta}";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $videoconsulta["medico_idmedico"],
            "contexto" => "Finalización VC",
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
     * Método que envía el email de finalizacion de la videoconsulta..
     * Cuando finaliza la misma
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function enviarMailFinalizacionVC($idvideoconsulta) {
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        $consulta = $this->get($idvideoconsulta);
        //verificamos que la videoconsulta le corresponda al medico en session
        if ($consulta["medico_idmedico"] != $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {
            $this->setMsg(["result" => false, "msg" => "No se pudo recuperar la videoconsulta"]);
            return false;
        }
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

        $ManagerMedico = $this->getManager("ManagerMedico");
        $consulta["medico"] = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $consulta["medico"]["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
        $consulta["motivoVideoConsulta"] = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];

        $idperfilsaludconsulta = $this->getIdConclusion($idvideoconsulta);

//ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Votre Vidéo Consultation Nº" . $consulta["numeroVideoConsulta"] . " a déja été finalisé");

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("videoconsulta", $consulta);
        $smarty->assign("idperfilsaludconsulta", $idperfilsaludconsulta);

        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/mensaje_finalizacion_videoconsulta.tpl"));


        $email = $ManagerPaciente->getPacienteEmail($consulta["paciente_idpaciente"]);
        if ($email != "") {
            $mEmail->addTo($email);
            //header a todos los comentarios!
            if ($mEmail->send()) {
                return true;
            }
        }
        $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
        return false;
    }

    /**
     * Metodo que envia un mensaje via email a paciente cuando el medico acepta o toma una videoconsulta
     * 
     * @param type $idvideoconsulta
     */
    public function enviarMailAceptarVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);
        $email = $ManagerPaciente->getPacienteEmail($consulta["paciente_idpaciente"]);
        if ($email == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivoVideoConsulta", $motivo);
        $smarty->assign("videoconsulta", $consulta);
        $dia_nombre = getNombreCortoDia(date('N', strtotime($consulta["inicio_sala"])));
        $smarty->assign("dia_nombre", $dia_nombre);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $subject = "WorknCare: {$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a accepté votre demande de Vidéo Consultation Nº" . $consulta["numeroVideoConsulta"];
        $mEmail->setSubject($subject);
        $mEmail->setBody($smarty->Fetch("email/mensaje_aceptar_videoconsulta.tpl"));

        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     *  Metodo que envia un mensaje via email a paciente cuando el medico pospone una videoconsulta
     * 
     * @param type $idvideoconsulta
     */
    public function enviarMailPosponerVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);
        $email = $ManagerPaciente->getPacienteEmail($consulta["paciente_idpaciente"]);
        if ($email == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivoVideoConsulta", $motivo);
        $smarty->assign("videoconsulta", $consulta);
        $dia_nombre = getNombreCortoDia(date('N', strtotime($consulta["inicio_sala"])));
        $smarty->assign("dia_nombre", $dia_nombre);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $subject = "WorknCare | {$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a changé l'heure de votre Vidéo Consultation Nº" . $consulta["numeroVideoConsulta"];
        $mEmail->setSubject($subject);
        $mEmail->setBody($smarty->Fetch("email/mensaje_posponer_videoconsulta.tpl"));

        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente cuando se vence su video consulta
     * 
     * @param type $request
     */

    public function enviarMailRechazoVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
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

        $mEmail->setSubject(sprintf("WorknCare | Votre Vidéo Consultation Nº %s a été déclinée ", $consulta["numeroVideoConsulta"]));
        $mEmail->setBody($smarty->Fetch("email/mensaje_rechazo_videoconsulta.tpl"));
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

    /**
     * Método que se utiliza para enviar al paciente SMS cuando se acepta la VC
     * @return boolean
     */
    public function enviarSMSAceptarVC($idvideoconsulta) {
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);
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

        $aceptar_en = "";
        if ((int) $consulta["aceptar_en"] == 0) {
            $aceptar_en = "Le professionnel vous attend actuellement dans la salle!";
        } else {
            $dia_numero = date('d', strtotime($consulta["inicio_sala"]));
            if ($dia_numero != date("d", time())) {
                $dia_nombre = getNombreCortoDia(date('N', strtotime($consulta["inicio_sala"])));

                $aceptar_en = "Le professionnel vous attendra  dans la salle le {$dia_nombre} {$dia_numero} à " . date('H:i', strtotime($consulta["inicio_sala"])) . "hs.";
            } else {
                $aceptar_en = "Il vous attendra dans sa salle en Visio aujourd'hui à " . date('H:i', strtotime($consulta["inicio_sala"])) . "hs: ";
            }
        }

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a accepté votre demande. " .
                ".  {$aceptar_en} " . URL_ROOT . "patient/video-consultation/salle-attente.html";


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Aceptar VC",
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
     * Método que se utiliza para enviar al paciente SMS cuando se pospone la VC
     * @return boolean
     */
    public function enviarSMSPosponerVC($idvideoconsulta) {
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);
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

        $aceptar_en = "";
        if ((int) $consulta["aceptar_en"] == 0) {
            $aceptar_en = "Le professionnel vous attend actuellement dans la salle!";
        } else {
            $dia_numero = date('d', strtotime($consulta["inicio_sala"]));
            if ($dia_numero != date("d", time())) {
                $dia_nombre = getNombreCortoDia(date('N', strtotime($consulta["inicio_sala"])));

                $aceptar_en = "Le professionnel vous attendra  dans la salle le {$dia_nombre} {$dia_numero} à " . date('H:i', strtotime($consulta["inicio_sala"])) . "hs.";
            } else {
                $aceptar_en = "Il vous attendra dansa salle en Visio à " . date('H:i', strtotime($consulta["inicio_sala"])) . "hs aujourd'hui";
            }
        }

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a changé l'horaire de votre séance en Visio" .
                ".  {$aceptar_en}: " . URL_ROOT . "patient/video-consultation/salle-attente.html";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Aceptar VC",
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
     * Método que se utiliza para enviar al paciente SMS cuando se rechaza la VC
     * @return boolean
     */
    public function enviarSMSRechazoVC($idvideoconsulta) {
        $consulta = $this->get($idvideoconsulta);
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

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} a décliné votre demande de Visio. Motif: $motivo. " .
                URL_ROOT . "patient/video-consultation/declinees.html";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $consulta["medico_idmedico"],
            "contexto" => "Rechazo VC",
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
     * Método que se utiliza para enviar al paciente un mail cuando vence la VC
     *  Motivos: -se publico la VC y el profesional frecuente/Red no la acepta
     *          -Se pasaron 10 min del la fecha de inicio y la consulta no esta en curso
     * @return boolean
     */
    public function enviarMailVencimientoVC($idvideoconsulta) {

        //validamos la existencia del la consula express vencida
        $videoconsulta = $this->get($idvideoconsulta);
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "5") {
            $this->setMsg(["msg" => "Error. La video consulta no se encuentra vencida",
                "result" => false
            ]);
            return false;
        }


        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar

        $email = $ManagerPaciente->getPacienteEmail($videoconsulta["paciente_idpaciente"]);
        if ($email == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ",
                "result" => false
            ]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($videoconsulta["motivoVideoConsulta_idmotivoVideoConsulta"]);


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();



        $smarty->assign("paciente", $paciente);
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
        $smarty->assign("videoconsulta", $videoconsulta);



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare : votre demande de Vidéo Consultation  Nº %s a expiré  ", $videoconsulta["numeroVideoConsulta"]));

        $mEmail->setBody($smarty->Fetch("email/mensaje_vencimiento_videoconsulta.tpl"));
        $mEmail->addTo($email);



        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando vence la VC
     *  Motivos: -se publico la VC y el profesional frecuente/Red no la acepta
     *          -Se pasaron 10 min del la fecha de inicio y la consulta no esta en curso
     * @return boolean
     */
    public function enviarSMSVencimientoVC($idvideoconsulta) {
        $videoconsulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);


        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);


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

        $cuerpo = "Votre demande de Visio a expiré: " .
                URL_ROOT . "patient/video-consultation/expirees-" . $videoconsulta["idvideoconsulta"] . ".html";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $videoconsulta["medico_idmedico"],
            "contexto" => "Vencimiento VC",
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
     * Método que se utiliza para enviar al paciente un mail cuando el médico reembolsa la VC
     * @return boolean
     */
    public function enviarMailReembolsoVC($idvideoconsulta) {

        //validamos la existencia del la consula express vencida
        $videoconsulta = $this->get($idvideoconsulta);
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "5") {
            $this->setMsg(["msg" => "Error. La video consulta no se encuentra vencida",
                "result" => false
            ]);
            return false;
        }


        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
        //Si el email es vació puede ser que sea un miembro del grupo familiar

        $email = $ManagerPaciente->getPacienteEmail($videoconsulta["paciente_idpaciente"]);
        if ($email == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ",
                "result" => false
            ]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($videoconsulta["motivoVideoConsulta_idmotivoVideoConsulta"]);


        //envio de la invitacion por mail

        $smarty = SmartySingleton::getInstance();



        $smarty->assign("paciente", $paciente);
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
        $smarty->assign("videoconsulta", $videoconsulta);



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject(sprintf("WorknCare | Votre Vidéo Consultation Nº %s a été remboursée par le professionnel ", $videoconsulta["numeroVideoConsulta"]));

        $mEmail->setBody($smarty->Fetch("email/mensaje_reembolso_videoconsulta.tpl"));
        $mEmail->addTo($email);

        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando el médico reembolsa la VC
     * @return boolean
     */
    public function enviarSMSReembolsoVC($idvideoconsulta) {
        $videoconsulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);


        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);


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

        $cuerpo = "Votre demande de Visio Nº" . $videoconsulta["numeroVideoConsulta"] . " a été remboursée par le professionnel: " .
                URL_ROOT . "patient/video-consultation/expirees-" . $videoconsulta["idvideoconsulta"] . ".html";



        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $videoconsulta["medico_idmedico"],
            "contexto" => "Reembolso VC",
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
     * Método que se utiliza para enviar al medico SMS cuando le asignan una VC
     * @return boolean
     */
    public function enviarSMSNuevaVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $ManagerMedico = $this->getManager("ManagerMedico");
        if ($consulta["tipo_consulta"] == "1") {

            $medico = $ManagerMedico->get($consulta["medico_idmedico"]);

            if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
                $numero = $medico["numeroCelular"];
                $cuerpo = "Nouvelle demande en Visio: "
                        . URL_ROOT . "professionnel/video-consultation/recues.html";
            } else {
                return false;
            }


            /**
             * Inserción del SMS en la lista de envio
             */
            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'M',
                //"paciente_idpaciente" => $paciente["idpaciente"],
                "medico_idmedico" => $medico["idmedico"],
                "contexto" => "Nueva VC",
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
                    $cuerpo = "WorknCare | Nouvelle demande de Vidéo Consultation  publiée sur la plateforme en lien avec votre spécialité: "
                            . URL_ROOT . "professionnel/video-consultation/publiees-sur-la-plateforme.html";

                    /**
                     * Inserción del SMS en la lista de envio
                     */
                    $ManagerLogSMS = $this->getManager("ManagerLogSMS");
                    $sms = $ManagerLogSMS->insert([
                        "dirigido" => 'M',
                        //"paciente_idpaciente" => $paciente["idpaciente"],
                        "medico_idmedico" => $medico["idmedico"],
                        "contexto" => "Nueva VC",
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
    public function enviarSMSCancelacionConsulta($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);

        $ManagerMedico = $this->getManager("ManagerMedico");

        $medico = $ManagerMedico->get($consulta["medico_idmedico"]);
        if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
            $numero = $medico["numeroCelular"];
            $cuerpo = "Demande de Vidéo Consultation Nº" . $consulta["numeroVideoConsulta"] . " annulée";
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
            "contexto" => "Cancelar VC",
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
     * Método que se utiliza para enviar al medico SMS cuando tiene proxima una VC
     * @return boolean
     */
    public function enviarSMSMedicoProximaVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $ManagerMedico = $this->getManager("ManagerMedico");

        //Medico
        $medico = $ManagerMedico->get($consulta["medico_idmedico"]);

        if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {

            $cuerpo = "Votre Visio commence dans moins de 5 minutes: "
                    . URL_ROOT . "professionnel/video-consultation/salle-attente.html";
        } else {
            return false;
        }

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms_medico = $ManagerLogSMS->insert([
            "dirigido" => 'M',
            //"paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $medico["idmedico"],
            "contexto" => "Proxima VC",
            "texto" => $cuerpo,
            "numero_cel" => $medico["numeroCelular"]
        ]);


        if ($sms_medico) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente SMS cuando tiene proxima una VC
     * @return boolean
     */
    public function enviarSMSPacienteProximaVC($idvideoconsulta) {

        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");

        //Paciente
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

        if ($paciente["numeroCelular"] != "" && $paciente["celularValido"]) {
            $cuerpo = "Votre Visio commence dans moins de 5 minutes: "
                    . URL_ROOT . "patient/video-consultation/salle-attente.html";
        } else {
            return false;
        }


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms_paciente = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "contexto" => "Proxima VC",
            "texto" => $cuerpo,
            "numero_cel" => $paciente["numeroCelular"]
        ]);


        if ($sms_paciente) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /**
     * Metodo que envia un mensaje via email a medico antes de que comience su proxima VC
     * 
     * @param type $idvideoconsulta
     */
    public function enviarMailMedicoProximaVC($idvideoconsulta) {

        //obtenemos la informacion de la VC
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $mensaje = $this->getManager("ManagerMensajeVideoConsulta")->getPrimerMensaje($idvideoconsulta);
        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"]);
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);

        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();


        if ($medico["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del medico ", "result" => false]);
            return false;
        }



        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
        $smarty->assign("videoconsulta", $consulta);
        $smarty->assign("mensaje", $mensaje["mensaje"]);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_proxima_videoconsulta_medico.tpl"));
        $mEmail->setSubject("WorknCare: Votre prochaine Vidéo Consultation commence dans moins de 5 minutes");

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
     * Metodo que envia un mensaje via email al paciente antes de que comience su proxima VC
     * 
     * @param type $idvideoconsulta
     */
    public function enviarMailPacienteProximaVC($idvideoconsulta) {

        //obtenemos la informacion de la VC
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $mensaje = $this->getManager("ManagerMensajeVideoConsulta")->getPrimerMensaje($idvideoconsulta);
        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"]);
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($medico["idmedico"]);

        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();


        if ($paciente["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }



        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
        $smarty->assign("videoconsulta", $consulta);
        $smarty->assign("mensaje", $mensaje["mensaje"]);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_proxima_videoconsulta_paciente.tpl"));
        $mEmail->setSubject("WorknCare: Votre prochaine Vidéo Consultation commence dans moins de 5 minutes");

        $email = $paciente["email"];
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

    /*     * Metodo que envia un mensaje via email a medico si esta dirigida a profesional frecuente cuando se crea
     * 
     * @param type $idvideoconsulta
     */

    public function enviarMailNuevaVC($idvideoconsulta) {

        //obtenemos la informacion de la VC
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $mensaje = $this->getManager("ManagerMensajeVideoConsulta")->getPrimerMensaje($idvideoconsulta);
        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"]);



        $ManagerArchivosMensajeVideoConsulta = $this->getManager("ManagerArchivosMensajeVideoConsulta");
        //Obtengo todas las imágenes del perfil de salud estudio
        $list_imagenes = $ManagerArchivosMensajeVideoConsulta->getListImages($mensaje["idmensajeVideoConsulta"]);

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
            $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
            $smarty->assign("mensaje", $mensaje["mensaje"]);
            $smarty->assign("imagenes", $list_imagenes);



            $mEmail = $this->getManager("ManagerMail");
            $mEmail->setHTML(true);
            $mEmail->setBody($smarty->Fetch("email/mensaje_nueva_videoconsulta.tpl"));
            $mEmail->setSubject(sprintf("WorknCare | Nouvelle demande de Vidéo Consultation Nº %s", $consulta["numeroVideoConsulta"]));

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
                $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
                $smarty->assign("mensaje", $mensaje["mensaje"]);


                $mEmail = $this->getManager("ManagerMail");
                $mEmail->setHTML(true);
                $mEmail->setBody($smarty->Fetch("email/mensaje_nueva_videoconsulta_red.tpl"));
                $mEmail->setSubject(sprintf("WorknCare | Nouvelle demande de Vidéo Consultation ", $consulta["numeroVideoConsulta"]));

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
     * @param type $idvideoconsulta
     */
    public function enviarMailCancelacionConsulta($idvideoconsulta) {

        //obtenemos la informacion de la CE
        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"]);


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
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_cancelar_videoconsulta.tpl"));
        $mEmail->setSubject(sprintf("WorknCare | Demande de Vidéo Consultation Nº %s annulée", $consulta["numeroVideoConsulta"]));

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

    /*     * Metodo que invoca las funciones encargadas del envio de un mail y un SMS al paciente cuando el medico ingresa a una sala de videoconsulta
     * 
     * @param type $idvideoconsulta
     */

    public function notificarMedicoEnSala($idvideoconsulta) {
        $videoconsulta = $this->get($idvideoconsulta);
        $client = new XSocketClient();
        $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);
        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
        $notify["text"] = "Le professionnel est entré dans le Cabinet Virtuel";
        $notify["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
        $notify["style"] = "video-consulta";
        $notify["type"] = "ingreso_sala";
        $client->emit('notify_php', $notify);
        if ($videoconsulta["notificacion_ingreso_sala"] != "1") {
            $sms = $this->enviarSMSMedicoEnSala($idvideoconsulta);
            $mail = $this->enviarMailMedicoEnSala($idvideoconsulta);

            parent::update(["notificacion_ingreso_sala" => 1], $idvideoconsulta);
            if (!$sms && !$mail) {
                $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje notificando al paciente su ingreso a la sala"]);

                return false;
            }
            $this->setMsg(["result" => true, "msg" => "Se ha notificado al paciente su ingreso a la sala"]);

            return true;
        } else {
            $this->setMsg(["result" => true, "msg" => "Ya se ha notificado al paciente de su ingreso a la sala"]);

            return true;
        }
    }

    /**
     * Método que envía un sms al paciente cuando el medico a ingresado a la sala para la videoconsulta..
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function enviarSMSMedicoEnSala($idvideoconsulta) {

        $videoconsulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
        $medico = $this->getManager("ManagerMedico")->get($videoconsulta["medico_idmedico"]);
        $medico["titulo_profesional"] = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);


        //Quiere decir que no es paciente titular
        if ($paciente["usuarioweb_idusuarioweb"] == "") {
            //Obtengo el paciente titular para el envío del email
            $paciente_titular = $ManagerPaciente->getPacienteTitular($videoconsulta["paciente_idpaciente"]);


            if ($paciente_titular["celularValido"] == 0) {
                $this->setMsg(array("msg" => "El paciente no tiene configurado un numero de celular",
                    "result" => false
                        )
                );
                return false;
            } else {
                $numero = $paciente_titular["numeroCelular"];
            }
        } else {
            //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
            if ($paciente["celularValido"] == 0) {
                $this->setMsg(["msg" => "El paciente no tiene configurado un numero de celular", "result" => false]);
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

        $cuerpo = "{$medico["titulo_profesional"]["titulo_profesional"]} {$medico["nombre"]} {$medico["apellido"]} vous attend en salle (Visio):" .
                URL_ROOT . "patient/video-consultation/salle-attente.html";


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $videoconsulta["medico_idmedico"],
            "contexto" => "Ingreso Sala Videoconsulta",
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
     * Método que envía el email al paciente cuando el medico a ingresado a la sala para la videoconsulta..
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function enviarMailMedicoEnSala($idvideoconsulta) {
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        $consulta = $this->get($idvideoconsulta);
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

        $ManagerMedico = $this->getManager("ManagerMedico");
        $consulta["medico"] = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $consulta["medico"]["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);
        $consulta["motivoVideoConsulta"] = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];



//ojo solo arnet local
        $mEmail->setPort("587");

        if ($consulta["medico"]["sexo"] == 1) {
            $sexo = "Mr";
        } else {
            $sexo = "Mme";
        }
        $mEmail->setSubject("WorknCare: {$consulta["medico"]["tituloprofesional"]} {$consulta["medico"]["nombre"]} {$consulta["medico"]["apellido"]} vous attend dans son cabinet de Vidéo Consultation ");

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("videoconsulta", $consulta);


        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/mensaje_medico_ingreso_sala_videoconsulta.tpl"));


        $email = $ManagerPaciente->getPacienteEmail($consulta["paciente_idpaciente"]);
        if ($email != "") {
            $mEmail->addTo($email);
            //header a todos los comentarios!
            if ($mEmail->send()) {
                return true;
            }
        }
        $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje notificando al paciente su ingreso a la sala"]);
        return false;
    }

    /*     * Metodo que retorna el id del perfil de salud consulta correspondiene al cierre de la videoconsulta con las conclusiones por parte del medico
     * 
     * @param type $idvideoconsulta
     */

    public function getIdConclusion($idvideoconsulta) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("perfilsaludconsulta psc");
        $query->setWhere("psc.videoconsulta_idvideoconsulta=$idvideoconsulta and psc.is_cerrado=1");
        $rdo = $this->db->getRow($query->getSql());
        return $rdo["idperfilSaludConsulta"];
    }

    /*     * Metodo que retorna verdadero si la videoconsulta pertenece al paciente en sesion o un miembro del grupo familiar
     * 
     * @param type $idvideoconsulta
     * @return boolean
     */

    public function validarVideoConsultaPacienteSesion($idvideoconsulta) {

        $videoconsulta = $this->get($idvideoconsulta);
        $idpaciente_session = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
        if ($videoconsulta["paciente_idpaciente"] == $idpaciente_session) {
            return true;
        } else {
            $miembro = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($videoconsulta["paciente_idpaciente"], $idpaciente_session);
            if ($miembro["idpacienteGrupoFamiliar"] != "") {
                return true;
            } else {
                return false;
            }
        }
    }

    /*     * Metodo mediante el cual un prestador crea una videcosunta en nombre de un paciente hacia un medico
     * La VC se le publica como pendiente al medico y este continua el flujo normal 
     */

    public function crearVideoConsultaFromPrestador($request) {

        $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
        if ($request["paciente_idpaciente"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el paciente de la Video Consulta"]);
            return false;
        }
        if ($request["medico_idmedico"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el médico de la Video Consulta"]);
            return false;
        }
        if ($request["motivoVideoConsulta_idmotivoVideoConsulta"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Seleccione el motivo de la Video Consulta"]);
            return false;
        }
        if ($request["mensaje"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. Ingrese un detalle de la videoconsulta"]);
            return false;
        }
        $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
        if ($prestador["valorVideoConsulta"] == "" && $prestador["descuento"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error. No tiene configurado el valor de la videoconsulta"]);
            return false;
        }
        $this->db->StartTrans();
        //borramos las VC previas que pueda tener el paciente

        $delete_borrador = $this->deleteBorrador($request["paciente_idpaciente"]);

        if (!$delete_borrador) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
            return false;
        }

        $request["estadoVideoConsulta_idestadoVideoConsulta"] = 1;
        $request["consulta_step"] = 0;
        $request["tipo_consulta"] = 1;
        $request["precio_tarifa"] = 0;
        //guardamos el precio de la VC que establece el prestador
        //si el prestador ofrece un descuento, calculamos la tarifa sobre lo que cobra el medico y hacemos el descuento
        if ($prestador["descuento"] != "") {
            $preferencia_medico = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($request["medico_idmedico"]);
            if ($preferencia_medico["valorPinesVideoConsulta"] == "") {

                $this->setMsg(["result" => false, "msg" => "Error. El profesional no tiene configurado el valor de la videoconsulta para aplicar descuento"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $precio_tarifa_prestador = $preferencia_medico["valorPinesVideoConsulta"] - ($preferencia_medico["valorPinesVideoConsulta"] * (int) $prestador["descuento"] / 100);
        } else {
            $precio_tarifa_prestador = $prestador["valorVideoConsulta"];
        }
        $request["precio_tarifa_prestador"] = $precio_tarifa_prestador;
        $request["comision_prestador"] = 0;
        $request["from_prestador"] = 1;

        //Fechas de inicio 
        $request["fecha_inicio"] = $request["fecha_ultimo_mensaje"] = date("Y-m-d H:i:s");

        //Fecha vencimiento:Duracion de Profesionales frecuentes
        $request["fecha_vencimiento"] = strtotime('+2 hour', strtotime($request["fecha_inicio"]));

        $rdo = $this->insert($request);
        if (!$rdo) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo crear la Video Consulta"]);
            return false;
        }
        $request["idvideoconsulta"] = $rdo;
        $record["videoconsulta_idvideoconsulta"] = $rdo;
        $record["mensaje"] = $request["mensaje"];
        $record["emisor"] = "p";
        $record["fecha"] = date("Y-m-d H:i:s");

        $msj = $this->getManager("ManagerMensajeVideoConsulta")->basic_insert($record);
        if (!$msj) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo ingresar el mensaje la Video Consulta"]);
            return false;
        }
        //generamos el movimiento al paciente 
        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");

        $movimiento_cuenta = $ManagerMovimientoCuenta->processMovimientoPlublicacionVC($request);
        if (!$movimiento_cuenta) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg($ManagerMovimientoCuenta->getMsg());
            return false;
        }

        //notificamos al Medico 
        $this->enviarSMSNuevaVC($rdo);
        //enviamos el mail al/los medicos asociados 
        $this->enviarMailNuevaVC($request["idvideoconsulta"]);


        $this->db->CompleteTrans();
        $client = new XSocketClient();

        //notify
        $paciente = $this->getManager("ManagerPaciente")->get($request["paciente_idpaciente"]);
        $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
        $notify["text"] = "Nouvelle demande en Visio";
        $notify["medico_idmedico"] = $request["medico_idmedico"];
        $notify["style"] = "video-consulta";
        $client->emit('notify_php', $notify);
        //evento de cambio de estado
        $consulta = parent::get($rdo);

        $client->emit('cambio_estado_videoconsulta_php', $consulta);
        $this->setMsg(["result" => true, "msg" => "Video Consulta publicada con éxito"]);
        return true;
    }

    /**
     * Listado paginado de videoconsultas con turno elegibles para reintegro
     * @param array $request
     * @param type $idpaginate
     */
    public function get_listado_consultas_reintegro($request, $idpaginate = null) {

        //verificamos si el medico tiene habilitada la videocosulta


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10);
        }

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];


        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $query = new AbstractSql();

        $query->setSelect("t.*,
                            ps.idperfilSaludConsulta,
                            CASE t.estado_facturacion_caja 
                            
                            WHEN 1 THEN 'Facturée' 
                            WHEN 2 THEN 'Non éligible remboursement'
                            WHEN 3 THEN 'Refusée'
                            ELSE 'En attente'
                            END as estado_facturacion,
                            IF( t.estado_facturacion_caja IS NULL, 1,0) AS orden
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            
                            INNER JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                        ");




        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado

        $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4");

        //$query->addAnd("t.turno_idturno is not null");
        $query->addAnd("t.beneficia_reintegro=1 and t.grilla_idgrilla is not null");

        $query->setOrderBy("t.inicio_sala ASC");


        //añadimos los filtros de fecha

        if ($request["filtro_inicio"] != "") {
            $filtro_inicio = $this->sqlDate($request["filtro_inicio"]);
            $query->addAnd("t.fecha_inicio >= '{$filtro_inicio}'");
        }
        if ($request["filtro_fin"] != "") {
            $filtro_fin = $this->sqlDate($request["filtro_fin"]);
            $query->addAnd("t.fecha_inicio <= '{$filtro_fin}'");
        }



        $query->setGroupBy("t.idvideoconsulta");
        $query2 = new AbstractSql();
        $query2->setSelect("p.*");
        $query2->setFrom("({$query->getSql()}) p");
        $query2->setOrderBy("p.orden DESC, p.fecha_inicio DESC");
        $listado = $this->getListPaginado($query2, $idpaginate);




        if ($listado["rows"] && count($listado["rows"]) > 0) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");


            foreach ($listado["rows"] as $key => $value) {
                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_inicio"] != "") {
                    $listado["rows"][$key]["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
                }

                //Tengo que formatear la fecha de inicio.
                if ($value["fecha_fin"] != "") {
                    $listado["rows"][$key]["fecha_fin_format"] = fechaToString($value["fecha_fin"], 1);
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
            }



            return $listado;
        }
    }

    /**
     * Listado paginado de videoconsultas con turno elegibles para reintegro
     * @param array $request
     * @param type $idpaginate
     */
    public function get_listado_consultas_reintegro_resumen_periodo($request) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];




        $query = new AbstractSql();

        $query->setSelect("t.*,
                            ps.idperfilSaludConsulta,
                            CASE t.estado_facturacion_caja 
                            
                            WHEN 1 THEN 'Facturée' 
                            WHEN 2 THEN 'Non éligible remboursement'
                            WHEN 3 THEN 'Refusée'
                            ELSE 'En attente'
                            END as estado_facturacion
                            
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            
                            INNER JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                        ");




        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado

        $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4");
        if ($request["pendientes"] == 1) {
            $query->addAnd("t.estado_facturacion_caja IS NULL");
        } else {
            $query->addAnd("t.estado_facturacion_caja IS NOT NULL AND t.estado_facturacion_caja <>2");
        }


        //$query->addAnd("t.turno_idturno is not null");
        $query->addAnd("t.beneficia_reintegro=1 and t.grilla_idgrilla is not null");

        $query->setOrderBy("t.inicio_sala ASC");


        //añadimos los filtros de fecha

        if ($request["filtro_inicio"] != "") {

            $query->addAnd("t.fecha_inicio >= '{$request["filtro_inicio"]}'");
        }
        if ($request["filtro_fin"] != "") {

            $query->addAnd("t.fecha_inicio <= '{$request["filtro_fin"]}'");
        }



        $query->setGroupBy("t.idvideoconsulta");

        $listado = $this->getList($query);






        $ManagerPaciente = $this->getManager("ManagerPaciente");

        $ManagerGrillaExcepcion = $this->getManager("ManagerGrillaExcepcion");
        $ManagerGrilla = $this->getManager("ManagerGrilla");

        foreach ($listado as $key => $value) {
            //Tengo que formatear la fecha de inicio.
            if ($value["fecha_inicio"] != "") {
                $listado[$key]["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
            }

            //Tengo que formatear la fecha de inicio.
            if ($value["fecha_fin"] != "") {
                $listado[$key]["fecha_fin_format"] = fechaToString($value["fecha_fin"], 1);
            }

            $paciente = $ManagerPaciente->get($value["paciente_idpaciente"]);
            $paciente_titular = $ManagerPaciente->getPacienteTitular($value["paciente_idpaciente"]);


            $consulta["numero"] = $value["numeroVideoConsulta"];

            $consulta["fecha_inicio_format"] = fechaToString($value["fecha_inicio"], 1);
            $consulta["paciente_titular"] = "{$paciente_titular["nombre"]} {$paciente_titular["apellido"]}";
            $consulta["paciente"] = "{$paciente["nombre"]} {$paciente["apellido"]}";
            $consulta["ald"] = $paciente["beneficia_ald"] == "" ? "Non" : "ALD";
            //paciente ald pendiente-> non payee
            //paciente NO ald pendiente->  payee
            //paciente ald facturada-> voir decompte cpam
            //paciente NO ald facturada->  payee
            if ($request["pendientes"] == 1) {
                $consulta["estado"] = $paciente["beneficia_ald"] == "" ? "Payée" : "Non payée";
            } else {
                $consulta["estado"] = $paciente["beneficia_ald"] == "" ? "Payée" : "Voir décompte cpam";
            }

            $consulta["tarjeta_vitale"] = $paciente_titular["tarjeta_vitale"];

            if ($consulta["grilla_excepcion_idgrilla_excepcion"] != "") {
                $grilla = $ManagerGrillaExcepcion->get($value["grilla_excepcion_idgrilla_excepcion"]);
            } else {
                $grilla = $ManagerGrilla->get($value["grilla_idgrilla"]);
            }

            $consulta["codigo"] = $grilla["codigo"];
            $consulta["precio_tarifa"] = $value["precio_tarifa"];
            $listado[$key] = $consulta;
        }



        return $listado;
    }

    /**
     * Listado paginado de videoconsultas con turno elegibles para reintegro
     * @param array $request
     * @param type $idpaginate
     */
    public function get_totales_consultas_reintegro_periodo($request) {


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];




        $query = new AbstractSql();

        $query->setSelect("t.*,
                            ps.idperfilSaludConsulta,
                            IF( p.beneficia_ald = 1, precio_tarifa, 0 ) AS importe_videoconsultas_ald,
                            IF( p.beneficia_ald = 1, 1, 0 ) AS videoconsulta_ald,
                            IF( p.beneficia_ald IS NULL, precio_tarifa, 0 ) AS importe_videoconsultas_reintegro,
                            IF( p.beneficia_ald IS NULL, comision_doctor_plus, 0 ) AS importe_comision_videoconsulta_reintegro,
                            IF( p.beneficia_ald IS NULL, 1, 0 ) AS videoconsulta_reintegro 
                           
                            
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            
                            INNER JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                        ");




        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado

        $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4");

        //$query->addAnd("t.turno_idturno is not null");
        $query->addAnd("t.beneficia_reintegro=1 AND t.grilla_idgrilla is not null AND (t.estado_facturacion_caja IS NULL OR  t.estado_facturacion_caja =1)");

        $query->setOrderBy("t.inicio_sala ASC");



        //añadimos los filtros de fecha

        if ($request["filtro_inicio"] != "") {

            $query->addAnd("t.fecha_inicio >= '{$request["filtro_inicio"]}'");
        }
        if ($request["filtro_fin"] != "") {

            $query->addAnd("t.fecha_inicio <= '{$request["filtro_fin"]}'");
        }



        $query->setGroupBy("t.idvideoconsulta");


        $query2 = new AbstractSql();
        $query2->setSelect("
                 	IFNULL(SUM( importe_videoconsultas_reintegro ),'0.00') AS importe_videoconsultas_reintegro,
                        IFNULL(SUM( importe_comision_videoconsulta_reintegro ),'0.00') AS importe_comision_videoconsulta_reintegro,
                        IFNULL(SUM( videoconsulta_reintegro ),'0.00') AS total_videoconsulta_reintegro,
                        IFNULL(SUM( importe_videoconsultas_ald ),'0.00') AS importe_videoconsultas_ald,
                        IFNULL(SUM( videoconsulta_ald ),'0.00') AS total_videoconsulta_ald 
                       ");
        $query2->setFrom("({$query->getSql()}) t");
        $listado = $this->getList($query2);



        return $listado[0];
    }

    /**
     * Obtiene la cantidad  de videoconsultas con turno elegibles para reintegro pendientes
     * @param array $request
     * @param type $idpaginate
     */
    public function get_cantidad_consultas_reintegro_pendiente() {

        //verificamos si el medico tiene habilitada la videocosulta

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect("count(t.idvideoconsulta) as cant");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                            INNER JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                        ");



        $query->setWhere("t.medico_idmedico = $idmedico");
        //estado

        $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4");

        $query->addAnd("t.estado_facturacion_caja is null");
        $query->addAnd("t.beneficia_reintegro=1 and t.grilla_idgrilla is not null");

        $cant = $this->db->getOne($query->getSql());
        return $cant;
    }

    /**
     * Detalle de una Videoconsulta con turno elegible para reintegro
     * @param array $request
     * @param type $idpaginate
     */
    public function get_consulta_reintegro_detalle($idvideoconsulta) {

        //verificamos si el medico tiene habilitada la videocosulta

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();
        $query->setSelect("t.*,
                            
                            mc.motivoVideoConsulta,
                            ps.idperfilSaludConsulta,
                            CASE t.estado_facturacion_caja 
                            WHEN '' THEN 'En attente'
                            WHEN 1 THEN 'Facturée' 
                            WHEN 2 THEN 'Non éligible remboursement'
                            WHEN 3 THEN 'Refusée' END as estado_facturacion               
                        ");

        $query->setFrom("$this->table t 
                            INNER JOIN paciente p ON (p.idpaciente=t.paciente_idpaciente)
                          
                            INNER JOIN perfilsaludconsulta ps ON (ps.videoconsulta_idvideoconsulta=t.idvideoconsulta AND ps.is_cerrado = 1)
                            LEFT JOIN motivovideoconsulta mc ON (mc.idmotivoVideoConsulta=t.motivoVideoConsulta_idmotivoVideoConsulta)         
                        ");

        $query->setWhere("t.medico_idmedico = $idmedico and t.idvideoconsulta=$idvideoconsulta");
        //estado

        $query->addAnd("t.estadoVideoConsulta_idestadoVideoConsulta=4");

        //$query->addAnd("t.turno_idturno is not null");
        $query->addAnd("t.beneficia_reintegro=1 and t.grilla_idgrilla is not null");



        //añadimos los filtros de fecha

        $query->setGroupBy("t.idvideoconsulta");

        $consulta = $this->getList($query)[0];


        if ($consulta) {

            $ManagerPaciente = $this->getManager("ManagerPaciente");

            //Tengo que formatear la fecha de inicio.
            if ($consulta["fecha_inicio"] != "") {
                $consulta["fecha_inicio_format"] = fechaToString($consulta["fecha_inicio"], 1);
            }

            //Tengo que formatear la fecha de inicio.
            if ($consulta["fecha_fin"] != "") {
                $consulta["fecha_fin_format"] = fechaToString($consulta["fecha_fin"], 1);
            }


            //Traigo la informacion del paciente
            $consulta["paciente"] = $ManagerPaciente->get($consulta["paciente_idpaciente"]);

            //obtenemos el titular de la cuenta si es un familiar
            $realciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $consulta["paciente_idpaciente"]);
            if ($realciongrupo["pacienteTitular"] != "") {
                //Traigo la informacion del paciente titular
                $consulta["paciente_titular"] = $ManagerPaciente->get($realciongrupo["pacienteTitular"]);
                $consulta["paciente_titular"]["relacion"] = $this->getManager("ManagerRelacionGrupo")->get($realciongrupo["relacionGrupo_idrelacionGrupo"])["relacionGrupo"];
            }
            $profesional_frecuente_cabecera = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$consulta["paciente_idpaciente"], 1]);
            if ($profesional_frecuente_cabecera) {
                $consulta["medico_cabecera"] = $this->getManager("ManagerMedico")->get($profesional_frecuente_cabecera["medico_idmedico"]);
            }

            if ($consulta["grilla_excepcion_idgrilla_excepcion"] != "") {
                $consulta["grilla"] = $this->getManager("ManagerGrillaExcepcion")->get($consulta["grilla_excepcion_idgrilla_excepcion"]);
            } else {
                $consulta["grilla"] = $this->getManager("ManagerGrilla")->get($consulta["grilla_idgrilla"]);
            }



            return $consulta;
        }
    }

    /**
     * Metodo que establece estado de facturacion de una videoconsulta con reintegro
     * @param type $request
     * @return boolean
     */
    public function facturar_reintegro_consulta($request) {

        if ((int) $request["idvideoconsulta"] > 0) {
            if (($request["estado_facturacion_caja"] == 2 || $request["estado_facturacion_caja"] == 3) && $request["idmotivo_rechazo_reintegro"] == "") {
                $this->setMsg(["msg" => "Complete los campos obligatorios", "result" => false]);
                return false;
            }
            $videoconsulta = $this->get($request["idvideoconsulta"]);
            if ($videoconsulta["estado_facturacion_caja"] != "") {
                $this->setMsg(["msg" => "Se produjo un error al ingresar los datos", "result" => false]);
                return false;
            }
            if ($videoconsulta && $videoconsulta["medico_idmedico"] == $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {
                $record["estado_facturacion_caja"] = $request["estado_facturacion_caja"];

                if ($request["estado_facturacion_caja"] == 2 || $request["estado_facturacion_caja"] == 3) {
                    $record["idmotivo_rechazo_reintegro"] = $request["idmotivo_rechazo_reintegro"];
                } else {
                    //si no esta rechazada, quitamos el motivo
                    $record["idmotivo_rechazo_reintegro"] = "";
                }
                $request["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
                $request["medico_idmedico"] = $videoconsulta["medico_idmedico"];
                $this->db->StartTrans();
                $update = parent::update($record, $request["idvideoconsulta"]);

                $paciente = $this->getManager("ManagerPaciente")->get($videoconsulta["paciente_idpaciente"]);


                if ($paciente["beneficia_ald"] == 1) {
                    // si el paciente es ALD le devolvemos la plata
                    if ($request["estado_facturacion_caja"] == 1) {

                        //No se generan devoluciones de consultas de Pacientes ALD - Se gestiona aparte en la CPAM
                        /* $devolucion = $this->getManager("ManagerMovimientoCuenta")->processDevolucionVCPacienteALD($request);
                          if (!$devolucion) {
                          $this->setMsg(["msg" => "Se produjo un error al ingresar los datos", "result" => false]);
                          $this->db->FailTrans();
                          $this->db->CompleteTrans();
                          return false;
                          }
                          $devolucion_medico = $this->getManager("ManagerMovimientoCuenta")->processDevolucionVCMedicoALD($request);
                          if (!$devolucion_medico) {
                          $this->setMsg(["msg" => "Se produjo un error al ingresar los datos", "result" => false]);
                          $this->db->FailTrans();
                          $this->db->CompleteTrans();
                          return false;
                          } */
                    } else {
                        $medico = $this->getManager("ManagerMedico")->get($videoconsulta["medico_idmedico"]);
                        //si no le combramos comision en la VC, se la cobramos ahora
                        //si el paciente es NO ALD  le retenemos
                        if ((int) $medico["planProfesional"] == 0 && (int) $videoconsulta["comision_doctor_plus"] == 0) {



                            //Le tengo que sacar la comision
                            $comision_doctor_plus = $videoconsulta["precio_tarifa"] * COMISION_VC / 100;
                            $update_videoconsulta = parent::update([
                                        "comision_doctor_plus" => $comision_doctor_plus
                                            ], $videoconsulta[$this->id]);
                            if (!$update_videoconsulta) {
                                $this->setMsg(["msg" => "Error. No se pudo actualizar la video consulta", "result" => false]);
                                $this->db->FailTrans();
                                $this->db->CompleteTrans();

                                return false;
                            }
                            $process_comision_reintegro = $this->getManager("ManagerMovimientoCuenta")->processFacturacionReintegro($videoconsulta);

                            if (!$process_comision_reintegro) {

                                //MOdifico el estado a finalizado

                                $this->db->FailTrans();
                                $this->db->CompleteTrans();

                                //Retorno el mensaje de error del manager de movimiento cuenta,
                                $this->setMsg(["msg" => "Error. No se pudo actualizar la video consulta", "result" => false]);
                                return false;
                            }
                        }
                    }
                }


                $notif = $this->getManager("ManagerNotificacion")->createNotificacionFacturacionVideoConsulta($request);
                if ($update && $notif) {
                    $this->setMsg(["msg" => "Registro actualizado con éxito", "result" => true]);

                    $this->db->CompleteTrans();
                    return $update;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                }
            }
        }

        $this->setMsg(["msg" => "Se produjo un error al ingresar los datos", "result" => false]);
        return false;
    }

    /**
     * Método que genera un conjunto de rangos de horarios disponibles para aceptar una videoconsulta. 
     * Iniciando ahora y finalizando al final del día.
     * 
     */
    public function getRangosAceptarConsulta() {

        $rangos = [];
        $now = time();
        $start_hour = $now_hour = mktime(date("H", $now), 0, 0, date("m", $now), date("d", $now), date("Y", $now));

        //generamos horarios hasta las 00 del dia siguiente

        $end_hour = mktime(00, 00, 00, date("m", $now), date("d", $now) + 3, date("Y", $now));
        //*si es mañana el turno, concatenamos el dia*/
        $mañana = mktime(00, 00, 00, date("m", $now), date("d", $now) + 1, date("Y", $now));
        $dia_siguiente_format = getNombreCortoDia(date('N', $mañana)) . " " . date('d', $mañana) . " ";



        if ($start_hour < $end_hour) {

            while ($start_hour < $end_hour) {
                $inicio_bucket = date('Y-m-d H:i:s', $start_hour);
                $inicio_bucket_15 = date('Y-m-d H:i:s', strtotime('+15 minutes', $start_hour));
                $inicio_bucket_30 = date('Y-m-d H:i:s', strtotime('+30 minutes', $start_hour));
                $inicio_bucket_45 = date('Y-m-d H:i:s', strtotime('+45 minutes', $start_hour));

                $inicio_format = date('H:i', $start_hour);
                $fin_bucket = date('Y-m-d H:i:s', strtotime('+1 hour', $start_hour));
                $fin_format = date('H:i', strtotime('+1 hour', $start_hour));

                //*si es mañana el turno, concatenamos el dia, si es hoy solo el horario*/
                if (date("d", $start_hour) == date("d")) {
                    $bucket["format"] = $inicio_format . " - " . $fin_format;
                } else {
                    $bucket["format"] = $dia_siguiente_format . $inicio_format . " - " . $fin_format;
                }


//verificamos los espacios disponibles cada 15min
                $quarter["min-0"] = $this->verificarInicioSalaDisponible(["inicio" => $inicio_bucket]);
                $quarter["min-15"] = $this->verificarInicioSalaDisponible(["inicio" => $inicio_bucket_15]);
                $quarter["min-30"] = $this->verificarInicioSalaDisponible(["inicio" => $inicio_bucket_30]);
                $quarter["min-45"] = $this->verificarInicioSalaDisponible(["inicio" => $inicio_bucket_45]);

                //eliminamos los horarios que ya han pasado, solo con el primer bucket
                if ($now_hour == $start_hour) {
                    $quarter["min-0"] = false;
                    $quarter["min-15"] = $quarter["min-15"] && $now < strtotime('+15 minutes', $start_hour);
                    $quarter["min-30"] = $quarter["min-30"] && $now < strtotime('+30 minutes', $start_hour);
                    $quarter["min-45"] = $quarter["min-45"] && $now < strtotime('+45 minutes', $start_hour);
                }
                //etiquetas de cada slot de 15min
                $quarter["label-0"] = $inicio_format;
                $quarter["label-15"] = date('H:i', strtotime('+15 minutes', $start_hour));
                $quarter["label-30"] = date('H:i', strtotime('+30 minutes', $start_hour));
                $quarter["label-45"] = date('H:i', strtotime('+45 minutes', $start_hour));

                //time inicio de cada slot de 15min
                $quarter["time-0"] = $inicio_bucket;
                $quarter["time-15"] = $inicio_bucket_15;
                $quarter["time-30"] = $inicio_bucket_30;
                $quarter["time-45"] = $inicio_bucket_45;
                $bucket["quarters"] = $quarter;

                //Si no hay lugar disponible eliminamos el rango
                if (!$quarter["min-15"] && !$quarter["min-30"] && !$quarter["min-45"]) {
                    //intercambiamos inicio y fin con el proximo bucket
                    $inicio_bucket = $fin_bucket;
                    $start_hour = strtotime($inicio_bucket);
                    continue;
                }

                $rangos[] = $bucket;

                //intercambiamos inicio y fin con el proximo bucket
                $inicio_bucket = $fin_bucket;
                $start_hour = strtotime($inicio_bucket);
            }
        }

        return $rangos;
    }

    /**
     * Método que verifica si el medico ya tiene una consulta programada para el horario de inicio seleccionado
     */
    public function verificarInicioSalaDisponible($request) {
        $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $videoconsulta = $this->db->getRow("select idvideoconsulta from videoconsulta where inicio_sala='{$request["inicio"]}' and medico_idmedico=$idmedico and estadoVideoConsulta_idestadoVideoConsulta=2");
        return $videoconsulta["idvideoconsulta"] == "";
    }

    /**
     * Metodo que obtiene datos para el dashboard de las video consultas 
     */
    public function getDatosGraficoVideoConsultas() {

// para estadoConsultaExpress_idestadoConsultaExpress=5
        $query = new AbstractSql();
        $query->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query->setFrom("$this->table c INNER JOIN estadovideoconsulta e on (e.idestadoVideoConsulta=c.estadoVideoConsulta_idestadoVideoConsulta)");
        $query->setWhere("c.fecha_inicio is not null");
        $query->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query->addAnd("c.estadoVideoConsulta_idestadoVideoConsulta=5");
        $query->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");
        $listado = $this->getList($query);

        // para estadoConsultaExpress_idestadoConsultaExpress=4      
        $query4 = new AbstractSql();
        $query4->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query4->setFrom("$this->table c INNER JOIN estadovideoconsulta e on (e.idestadoVideoConsulta=c.estadoVideoConsulta_idestadoVideoConsulta)");
        $query4->setWhere("c.fecha_inicio is not null");
        $query4->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query4->addAnd("c.estadoVideoConsulta_idestadoVideoConsulta=4");
        $query4->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");
        $listado4 = $this->getList($query4);

        // para estadoConsultaExpress_idestadoConsultaExpress=3     
        $query3 = new AbstractSql();
        $query3->setSelect("DATE_FORMAT(c.fecha_inicio,'%Y-%m') as fecha, count(*) as cantidad");
        $query3->setFrom("$this->table c INNER JOIN estadovideoconsulta e on (e.idestadoVideoConsulta=c.estadoVideoConsulta_idestadoVideoConsulta)");
        $query3->setWhere("c.fecha_inicio is not null");
        $query3->addAnd("c.fecha_inicio > DATE_ADD(SYSDATE(), INTERVAL -365 DAY)");
        $query3->addAnd("c.estadoVideoConsulta_idestadoVideoConsulta=3");
        $query3->setGroupBy("DATE_FORMAT(c.fecha_inicio,'%Y-%m')");
        $listado3 = $this->getList($query3);

        $this->setMsg(["lista5vc" => $listado, "lista4vc" => $listado4, "lista3vc" => $listado3]);
    }

}

//END_class
?>