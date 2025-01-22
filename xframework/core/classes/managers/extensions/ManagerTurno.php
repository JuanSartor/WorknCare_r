<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	
 * 	Manager de turnos
 *
 */
class ManagerTurno extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "turno", "idturno");
    }

    /**
     * Método utilizado para obtener el turno de los pacientes
     * @param type $idturno
     * @return type
     */
    public function getTurno($idturno) {
        $query = new AbstractSql();

        $query->setSelect("*, t.estado as estado_turno");

        $query->setFrom("{$this->table} t
                                JOIN `consultorio` `c` ON (`t`.`consultorio_idconsultorio` = `c`.`idconsultorio`)
                                LEFT JOIN `medico` `m` ON (`t`.`medico_idmedico` = `m`.`idmedico`)
                                LEFT JOIN `paciente` `p` ON (`t`.`paciente_idpaciente` = `p`.`idpaciente`)
                                LEFT JOIN `usuarioweb` `uwm` ON (`m`.`usuarioweb_idusuarioweb` = `uwm`.`idusuarioweb`)
                                LEFT JOIN `pacientegrupofamiliar` `pgf` ON (`p`.`idpaciente` = `pgf`.`pacienteGrupo`)
				LEFT JOIN `servicio_medico` `sm` ON (`t`.`servicio_medico_idservicio_medico` = `sm`.`idservicio_medico`)
                            ");

        $query->setWhere("t.{$this->id} = {$idturno}");

        $row = $this->db->GetRow($query->getSql());

        if ($row) {
            $calendar = new Calendar();

            if ($row["fecha"] != "") {

                list($y, $m, $d) = preg_split("[-]", $row["fecha"]);
                $mes = $calendar->getMonths((int) $m);
                $dia = $calendar->getNameDayWeek($row["fecha"]);

                $horario_explode = explode(":", $row["horarioInicio"]);

                $row["fechaTurno_format"] = "{$dia} {$d} de {$mes} {$y}";

                $row["horarioTurno_format"] = "{$horario_explode[0]}:{$horario_explode[1]}";
            }
        }
        return $row;
    }

    /*
     * 	@author Xinergia <info@e-xinergia.com>
     *  @version 1.0
     *  Reserva un turno para un paciente logueado   
     *          
     */

    public function reservarTurno($request) {



        $idturno = $request["idturno"];
        $idpaciente_session = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        //verificamos si es el paciente en sesion
        if ($request["paciente_idpaciente"] != $idpaciente_session) {

            //verificamos si es familiar
            $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($request["paciente_idpaciente"], $idpaciente_session);
            if ($familiar["idpacienteGrupoFamiliar"] == "") {
                $this->setMsg(["result" => false, "msg" => "Error, debe ingresar los datos del paciente pare reservar un turno"]);
                return false;
            }
        }

        //Obtengo el turno
        $turno = $this->get($idturno);
        if (!$turno) {
            $this->setMsg(["result" => false, "msg" => "Error, no hemos podido reservar el turno, por favor compruebe los datos ingresados."]);
            return false;
        }

        $next_turnos = $this->getNextTurnoPaciente($request["paciente_idpaciente"], $turno["medico_idmedico"]);

        if (count($next_turnos) > 0) {
            $this->setMsg(["result" => false, "msg" => "Ud. actualmente posee un turno próximo para el profesional seleccionado. Debe concluir el mismo para solicitarle un nuevo turno al profesional"]);
            return false;
        }
        if ($this->turnoValido($request["idmedico"], $idturno)) {

            if ($this->turnoDisponible($request["paciente_idpaciente"], $idturno)) {

                //armo el array de turno
                if ($this->is_turno_videoconsulta($idturno)) {
                    $turno["motivoVideoConsulta_idmotivoVideoConsulta"] = (int) $request["motivoVideoConsulta_idmotivoVideoConsulta"];
                } else {
                    $turno["motivovisita_idmotivoVisita"] = (int) $request["motivovisita_idmotivoVisita"];
                }
                $turno["visitaPrevia"] = (int) $request["visitaPrevia"];
                $turno["particular"] = (int) $request["particular"];
                $turno["beneficia_reintegro"] = $request["beneficia_reintegro"] == 1 ? 1 : 0;
                //se reserva el turno ->Estado no confirmado por el paciente.. Pero creado
                $turno["estado"] = 4;
                $turno["anulado"] = "";
                $turno["fechaReservaTurno"] = date("Y-m-d H:i:s");

                $turno["paciente_idpaciente"] = $request["paciente_idpaciente"];
                $turno["idprograma_categoria"] = $request["idprograma_categoria"];

                $request["fechaSolicitudTurno"] = date("Y-m-d H:i:s");

                $this->db->StartTrans();
                $idturno = parent::update($turno, $turno["idturno"]);

                if ($idturno) {
                    $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
                    $insert_msj = $ManagerMensajeTurno->insert($request);
                    if (!$insert_msj) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg($ManagerMensajeTurno->getMsg());
                        return false;
                    }
                    $this->setMsg(["result" => true, "numero" => str_pad($idturno, 10, "0", STR_PAD_LEFT), "msg" => "Turno reservado", "id" => $idturno]);
                    // <-- LOG
                    $log["data"] = "Reason for medical appointment, patient consulting, profesional name, specialty, date & time appointment, appointment number, optional comentary";
                    $log["page"] = "Home page (connected) / Professional search";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Book Physical Consultation with connected Frequent Professional";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    $this->db->CompleteTrans();
                    return true;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["result" => false, "msg" => "Error, no hemos podido reservar el turno, por favor compruebe los datos ingresados."]
                    );

                    return false;
                }
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, el turno que desea reservar ya no se encuentra disponible"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, el turno que desea reservar no es válido"]);
            return false;
        }
    }

    /**
     * Método utilizado para la confirmación de reservar un turno cuando el paciente busca un turno con un medico
     * @param type $request
     */
    public function confirmarTurno($request) {
        $idturno = $request["id"];
        $turno = $this->get($idturno);

        if ($turno) {
            $turno["fechaSolicitudTurno"] = date("Y-m-d H:i:s");
            $turno["estado"] = 0;
            if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
                $turno["prestador_idprestador"] = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"];
            }
            $id = parent::update($turno, $idturno);
            $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"]);

            //autoconfirmacion de turnos, ejecuta la accion que realizaria el medico
            $is_turno_videoconsulta = $this->is_turno_videoconsulta($idturno);
            if ($medico["autoconfirmar_turno"] == 1 && !$is_turno_videoconsulta) {
                $record["medico_idmedico"] = $turno["medico_idmedico"];
                $record["autoconfirmar_turno"] = 1;
                $record["estado"] = 1;
                $confirm = $this->updateFromFrontendTurno($record, $idturno);
            }
            if ($is_turno_videoconsulta) {
                $this->getManager("ManagerVideoConsulta")->deleteBorrador($turno["paciente_idpaciente"]);
            }
            //insertamos el paciente al medico para que pueda visualiar el PF salud
            $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $turno["medico_idmedico"], "paciente_idpaciente" => $turno["paciente_idpaciente"]]);
            $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert(["medico_idmedico" => $turno["medico_idmedico"], "paciente_idpaciente" => $turno["paciente_idpaciente"]]);

            //Debo crear la notificacion con el turno que fue asociado
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $rdo_creacion_notificacion = $ManagerNotificacion->createNotificacionFromReservaTurno($turno["idturno"]);


            if ($id && ($rdo_creacion_notificacion || $confirm)) {
                $this->sendSolicitudTurnoEmail(["idturno" => $idturno]);
                //notificamos al medico de un nuevo turno
                $client = new XSocketClient();
                $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                $notify["medico_idmedico"] = $turno["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                if ($medico["autoconfirmar_turno"] == 1 && !$is_turno_videoconsulta) {
                    $notify["text"] = " Nouvelle Rendez-vous au cabinet";
                    $this->setMsg(["result" => true, "id" => $id, "msg" => "¡Su turno ha sido confirmado!"]);
                } else {
                    $notify["text"] = " Demande de Rendez-vous en Visio";
                    $this->setMsg(["result" => true, "id" => $id, "msg" => "Tu turno está ahora pendiente de confirmación por el médico. Te avisaremos por mail y SMS cuando haya sido confirmado"]);
                }
                $client->emit('notify_php', $notify);
                return $id;
            }
        }
        $this->setMsg(["result" => false, "msg" => "Error. No se pudo efectuar la confirmación del turno"]);
        return false;
    }

    /**
     * Método que realiza la confirmación de un turno perteneciente a una video consulta
     * @param type $request
     */
    public function confirmarPagoTurno($request) {

        $idturno = $request["idturno"];
        $turno = $this->get($idturno);

        $turno["beneficia_reintegro"] = $request["beneficia_reintegro"] == 1 ? 1 : 0;
        $cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
        if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
            //se verifica si tiene disponibles consultas sin cargo, o si se debe pagar la tarifa del prestador
            $monto = $this->getManager("ManagerMovimientoCuenta")->getMontoVideoConsultaTurnoPrestador($idturno);
        } else {
            $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
            if ($request["beneficia_reintegro"] == 1) {


                $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"], true);
                $tarifa_videconsulta = $this->getManager("ManagerGrilla")->getTarifaVideoConsulta($paciente, $medico);

                if ($tarifa_videconsulta["grilla"]["idgrilla_excepcion"] != "") {
                    $turno["grilla_excepcion_idgrilla_excepcion"] = $tarifa_videconsulta["grilla"]["idgrilla_excepcion"];
                    $turno["grilla_idgrilla"] = $tarifa_videconsulta["grilla"]["grilla_idgrilla"];
                }
                if ($tarifa_videconsulta["grilla"]["idgrilla"] != "") {
                    $turno["grilla_idgrilla"] = $tarifa_videconsulta["grilla"]["idgrilla"];
                }

                $monto = $tarifa_videconsulta["monto"];
            } else {
                $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($turno["medico_idmedico"]);
                $monto = $preferencia["valorPinesVideoConsultaTurno"];
            }
        }


        $this->db->StartTrans();



        $upd_turno = parent::update($turno, $turno["idturno"]);
        if (!$upd_turno) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $confirmacion_turno = $this->confirmarTurno(["id" => $idturno]);

        if (!$confirmacion_turno) {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }

        $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
        $insert_cuenta = $ManagerMovimientoCuenta->processMovimientoTurnoVideoConsulta([
            "idturno" => $idturno,
            "monto" => (float) $monto,
            "payment_method" => $request["payment_method"]
        ]);

        if (!$insert_cuenta) {
            $this->setMsg($ManagerMovimientoCuenta->getMsg());
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
        // <-- LOG
        $log["data"] = "Reason for medical appointment, patient consulting, profesional name, specialty, date & time appointment, choice confirmation consultation last 12 months, consultation fee, appointment number, optional comentary";
        $log["page"] = "Home page (connected)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Book Video Consultation with connected Frequent Professional";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 

        $this->db->CompleteTrans();
        return true;
    }

    /**
     * Averigua si un turno es valido
     *
     * */
    public function turnoValido($idmedico, $idturno) {
        $turno = $this->get($idturno);
        if ($turno["medico_idmedico"] != $idmedico) {
            //todo
            return false;
        } else {
            return true;
        }
    }

    /**
     * Averigua si un turno esta disponible con estado=0 (pendiente) o  estado=4 (reservado) por el paciente
     *
     * */
    public function turnoDisponible($idpaciente, $idturno) {
        $idpaciente_session = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        $turno = $this->get($idturno);

        //verificamos si el estado del turno es pendiente
        if ((int) $turno["estado"] == 0 && $turno["paciente_idpaciente"] == "") {
            //todo
            $this->setMsg(["result" => true, "msg" => "Turno disponible"]);
            return true;
        }//verificamnos si  el estado de turno esta siendo reservado y no esta confirmado por un paciente 
        elseif ($turno["estado"] == 4) {
            $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($idpaciente, $idpaciente_session);

            //verifico si el turno coincide con el paciente seleccionado, o si es el paciente en sesion o un familiar por si se cambia el paciente del turno

            if ($turno["paciente_idpaciente"] == $idpaciente || $familiar["idpacienteGrupoFamiliar"] != "") {
                $this->setMsg(["result" => true, "msg" => "Turno disponible"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error, el turno que desea reservar ya no se encuentra disponible"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error, el turno que desea reservar ya no se encuentra disponible"]);
            return false;
        }
    }

    /**
     * Metodo que permite reprogramar reprograma un turno. Cancelando el anterios y reservando uno nuevo disponible
     *
     * */
    public function reprogramar_turno($idpaciente, $idturno, $idturno_reprogramar) {

//verificamos si se encuentra disponible el nuevo turno;
        $turno_disponible = $this->turnoDisponible($idpaciente, $idturno_reprogramar);
        if (!$turno_disponible) {
            return false;
        }
        //buscamos el turno anterior
        $turno = $this->getTurno($idturno);
        //Corroboro que el turno elegido sea del paciente o de alguno de los pacientes
        $idpaciente_titular = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        if ($idpaciente_titular != $turno["paciente_idpaciente"] && $turno["pacienteTitular"] != $idpaciente_titular) {
            $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
            return false;
        }

        //buscamos el turno nuevo
        $turno_nuevo = $this->getTurno($idturno_reprogramar);
        $this->db->StartTrans();
        if ($turno) {

            //si es turno de videoconsulta la elimino
            $turno_videoconsulta = 0;
            if ($this->is_turno_videoconsulta($idturno)) {
                $turno_videoconsulta = 1;


                //actualizamos la videoconsulta correspeondiente
                $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $idturno);
                if ($videoconsulta["idvideoconsulta"] != "") {
                    $recordVC["turno_idturno"] = $idturno_reprogramar;
                    $recordVC["fecha_inicio"] = date("Y-m-d H:i:s");
                    $recordVC["inicio_sala"] = $turno_nuevo["fecha"] . " " . $turno_nuevo["horarioInicio"];
                    $recordVC["fecha_vencimiento"] = strtotime('+' . VIDEOCONSULTA_VENCIMIENTO_SALA . ' minutes', strtotime($recordVC["inicio_sala"]));

                    $updateVC = $ManagerVideoConsulta->update($recordVC, $videoconsulta["idvideoconsulta"]);
                    if (!$updateVC) {
                        $this->setMsg(["msg" => "Error. No se ha podido reprogramar el turno seleccionado", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }
            }


            //Tengo que modificar el turno anterior y enviar una notificación al médico
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

            $update = parent::update($update_turno, $idturno);

            //Colocamos los datos en el nuevo turno
            $update_turno_nuevo = array(
                "estado" => $turno["estado_turno"],
                "comentario" => $turno["comentario"],
                "paciente_idpaciente" => $turno["paciente_idpaciente"],
                "fechaSolicitudTurno" => date("Y-m-d H:i:s"),
                "fechaReservaTurno" => date("Y-m-d H:i:s"),
                "fechaCambioEstado" => date("Y-m-d H:i:s"),
                "motivovisita_idmotivoVisita" => $turno["motivovisita_idmotivoVisita"],
                "visitaPrevia" => $turno["visitaPrevia"],
                "particular" => $turno["particular"],
                "obraSocial_idobraSocial" => $turno["obraSocial_idobraSocial"],
                "planObraSocial_idplanObraSocial" => $turno["planObraSocial_idplanObraSocial"],
                "perfilSaludConsulta_idperfilSaludConsulta" => $turno["perfilSaludConsulta_idperfilSaludConsulta"],
                "stripe_payment_intent_id" => $turno["stripe_payment_intent_id"],
                "stripe_payment_method" => $turno["stripe_payment_method"],
                "pago_stripe" => $turno["pago_stripe"],
                "idprograma_categoria" => $turno["idprograma_categoria"]
            );

            $update_nuevo = parent::update($update_turno_nuevo, $idturno_reprogramar);

            //movemos los mensajes del turno
            $ManagerMensajeTurno = $this->getManager("ManagerMensajeTurno");
            $mensaje_turno = $ManagerMensajeTurno->getListadoMensajes($idturno, $idpaciente);

            if ($mensaje_turno) {
                $upd_mensaje = $ManagerMensajeTurno->update(["turno_idturno" => $idturno_reprogramar], $mensaje_turno["idmensajeTurno"]);
                if (!$upd_mensaje) {
                    $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }
            //cambiamos la informacion del movimiento de cuenta si es una videoconsulta 
            if ($turno_videoconsulta) {
                $query = new AbstractSql();
                $query->setSelect("*");
                $query->setFrom("movimientocuenta");
                $query->setWhere("turno_idturno=$idturno");
                $query->addAnd("paciente_idpaciente=" . $idpaciente);
                $query->addAnd("is_ingreso=0");

                $query->setOrderBy("fecha DESC");
                $movimiento_cuenta = $this->getList($query)[0];
                $upd_movimiento = $this->getManager("ManagerMovimientoCuenta")->update(["turno_idturno" => $idturno_reprogramar], $movimiento_cuenta["idmovimientoCuenta"]);
                if (!$upd_movimiento) {
                    $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //cambiamos la informacion de la notificacion anterior
            $queryNotificacion = new AbstractSql();
            $queryNotificacion->setSelect("idnotificacion");
            $queryNotificacion->setFrom("notificacion");
            $queryNotificacion->setWhere("turno_idturno=$idturno");
            $queryNotificacion->addAnd("paciente_idpaciente_emisor=" . $idpaciente);
            $queryNotificacion->setOrderBy("fechaNotificacion DESC");

            $notificacion_reserva = $this->getList($queryNotificacion)[0];
            $upd_notificacion_reserva = $this->getManager("ManagerNotificacion")->update(["estado_turno" => 6], $notificacion_reserva["idnotificacion"]);
            if (!$upd_notificacion_reserva) {
                $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            //Envío la notificacion al medico de la reprogramacion
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $notificacion = $ManagerNotificacion->createNotificacionFromReprogramacionTurnoPaciente($idturno_reprogramar, $idturno);

            $record_mail["idturno"] = $turno["idturno"];
            $record_mail["idturno_reprogramar"] = $idturno_reprogramar;
            $record_mail["idpaciente"] = $turno["paciente_idpaciente"];
            $this->sendReprogramacionTurnoPacienteEmail($record_mail);

            if ($update && $update_nuevo && $notificacion) {
                //notificamos al medico
                $client = new XSocketClient();
                $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                if ($turno_videoconsulta) {
                    $notify["text"] = "Rendez-vous de Vidéo Consultation reporté";
                } else {
                    $notify["text"] = "Rendez-vous au cabinet reporté";
                }

                $notify["medico_idmedico"] = $turno["medico_idmedico"];
                $notify["style"] = "notificacion";
                $notify["type"] = "notificacion";
                $client->emit('notify_php', $notify);

                //notificamos el evento al paciente
                $client->emit('cambio_estado_turno_php', $turno);

                // <-- LOG
                $log["data"] = "Reason for medical appointment, patient consulting, profesional name, specialty, date & time appointment, appointment number, optional comentary";
                $log["page"] = "Home page (connected)";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Reschedule Booking Physical Consultation with connected Frequent Professional";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                $this->db->CompleteTrans();

                $this->setMsg(["result" => true, "msg" => "Se ha reprogramado su turno con éxito"]);
                return true;
            }
        }

        $this->db->FailTrans();
        $this->db->CompleteTrans();

        $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
        return false;
    }

    /**
     * Método que obtiene la cantidad de turnos que posee un paciente.
     * La cantidad de turnos, (validos, no anulados y que no han sido atendidos).
     * @param type $idpaciente
     * @return int
     */
    public function getCantidadTurnosValidosPaciente($idpaciente, $fecha = null) {
        if ($idpaciente != "") {


            $query = new AbstractSql();
            $query->setSelect("COUNT(t.idturno) as cantidad_turnos");
            $query->setFrom("$this->table t");
            $query->setWhere("t.paciente_idpaciente = $idpaciente");
            $query->addAnd("t.estado = 1");


            if (!is_null($fecha)) {
                $fecha = $this->sqlDate($fecha);
                $query->addAnd("t.fecha = '$fecha'");
            } else {
                $query->addAnd("t.fecha>SYSDATE()");
            }


            $rdo = $this
                    ->db
                    ->Execute($query->getSql())
                    ->FetchRow();
            if (!$rdo) {
                return 0;
            } else {
                return $rdo["cantidad_turnos"];
            }
        }
    }

    /**
     * Método que obtiene la cantidad de turnos que posee un medico.
     * La cantidad de turnos, (validos, no anulados y que no han sido atendidos).
     * @param type $idmedico
     * @return int
     */
    public function getCantidadTurnosValidosMedicos($idmedico, $fecha = null) {

        $query = new AbstractSql();
        $query->setSelect("COUNT(t.idturno) as cantidad_turnos");
        $query->setFrom("$this->table t ");
        $query->setWhere("t.medico_idmedico = $idmedico");
        $query->addAnd("t.estado = 1");
        $query->addAnd("t.anulado = 0");
        $query->addAnd("t.asistenciaPaciente IS NULL");


        if (!is_null($fecha)) {
            list($m, $d, $y) = preg_split("[/]", $fecha);
            $fecha_format = $this->sqlDate(date("d/m/Y", mktime(0, 0, 0, $m, $d, $y)), '-', true);
            $query->addAnd("t.fecha = '$fecha_format'");
        }



        $rdo = $this
                ->db
                ->Execute($query->getSql())
                ->FetchRow();
        if (!$rdo) {
            return 0;
        } else {
            return $rdo["cantidad_turnos"];
        }
    }

    /**
     * Método que obtiene los profesionales ordenados 
     * @param type $idpaciente
     * @param type $frecuentes
     * @return boolean
     */
    public function getProfesionalesTurnoPaciente($idpaciente, $frecuentes = false) {


        $query = new AbstractSql();
        $query->setSelect("COUNT(t.idturno) as cantidad_turnos, t.medico_idmedico");
        $query->setFrom("$this->table t");
        $query->setWhere("t.paciente_idpaciente = $idpaciente");
        $query->setGroupBy("t.medico_idmedico");
        $query->setOrderBy("cantidad_turnos DESC");

        $list = $this->getList($query);
        $tamanio_lista = count($list);


        if ($tamanio_lista > 0) {
            //La cantidad de profesionales, va a depender si se requieren los frecuentes o no.
            //Si se requieren los frecuentes se listaran los que se deseen (3 profesionales por ejemplo)
            if (!$frecuentes) {
                $cantidad = $tamanio_lista;
            } else {
                if ($frecuentes <= $tamanio_lista) {
                    $cantidad = $frecuentes;
                } else {
                    $cantidad = $tamanio_lista;
                }
            }

            $managerMedico = $this->getManager("ManagerMedico");
            $extra = array();
            for ($i = 0; $i < $cantidad; $i++) {
                $extra[$i] = $managerMedico->get($list[$i]["medico_idmedico"]);
            }
            return $extra;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con la agenda del paciente.
     * Los turnos que el paciente posee
     * @param type $idpaciente
     * @return boolean
     */
    public function getAgendaPaciente($idpaciente) {

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("$this->table t");
        $query->setWhere("t.paciente_idpaciente = $idpaciente");
        $query->addAnd("t.estado = 1");
        $query->addAnd("t.anulado = 0");
        $query->addAnd("t.asistenciaPaciente IS NULL");

        $list = $this->getList($query);


        $managerMedico = $this->getManager("ManagerMedico");
        foreach ($list as $key => $turno) {
            $list[$key]["medico"] = $managerMedico->get($turno["medico_idmedico"]);
        }

        if (count($list) > 0) {
            return $list;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna un listado con la agenda del paciente.
     * Los turnos que el paciente posee + los eventos
     * @param type $idpaciente
     * @return boolean
     */
    public function getAgendaPacienteAndEventos($request, $idpaginate = NULL) {

        $idpaciente = $request["idpaciente"];
        $query = new AbstractSql();
        $hoy = date("Y-m-d");
        $query->setSelect("u.id, u.fecha, u.tipo, u.horario, u.tipo_turno_evento, u.comentario, u.medico_idmedico");
        $query->setFrom(" 
              (
                        (select idturno as id, fecha, 'turno' as tipo, horarioInicio as horario, 'Turno' as tipo_turno_evento, '' as comentario, medico_idmedico
                        from turno
                        where paciente_idpaciente = $idpaciente
                                AND estado <> 3 
                                AND anulado = 0
                                AND asistenciaPaciente IS NULL
                                AND fecha > '$hoy'
                        )
                union
                        (
                        select ideventopaciente as id, fecha, 'evento' as tipo, horaEvento as horario, t.temaevento as tipo_turno_evento, comentario, '' as medico_idmedico
                        from eventopaciente e join temaevento t on (e.temaevento_idtemaevento = t.idtemaevento)
                        where paciente_idpaciente = $idpaciente
                                AND fecha > '$hoy'
                        )
                ) as u
                   ");
        //$query->setLimit("0,4");

        if (isset($request["do_reset"]) && $request["do_reset"] == "1") {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 4, true);
        }

        $list = $this->getList($query, false, $idpaginate);


        $managerMedico = $this->getManager("ManagerMedico");
        foreach ($list as $key => $turno) {
            if ($turno["medico_idmedico"] != "") {
                $list[$key]["medico"] = $managerMedico->get($turno["medico_idmedico"]);
            }
        }


        if (count($list) > 0) {
            return $list;
        } else {
            return false;
        }
    }

    /**
     * Retorno de la cantidad total de la agenda del paciente (los eventos + turnos).
     * Necesario para la paginación
     * @param type $request
     * @return int
     */
    public function getCantidadAgendaPacienteAndEventos($request) {

        $idpaciente = $request["idpaciente"];
        $query = new AbstractSql();
        $hoy = date("Y-m-d");
        $query->setSelect("t1.cant as cant1, t2.cant as cant2");
        $query->setFrom(" 
              
                    (select COUNT(idturno) as cant
                    from turno
                    where paciente_idpaciente = $idpaciente
                            AND anulado = 0
                            AND asistenciaPaciente IS NULL
                            AND fecha > '$hoy'
                    ) as t1,
                    (
                    select COUNT(e.ideventopaciente) as cant
                    from eventopaciente e join temaevento t on (e.temaevento_idtemaevento = t.idtemaevento)
                    where paciente_idpaciente = $idpaciente
                            AND fecha > '$hoy'
                    ) as t2
                
                   ");

        $rdo = $this->db->Execute($query->getSql())->FetchRow();
        if (!$rdo)
            return 0;
        else {
            return (int) $rdo["cant1"] + (int) $rdo["cant2"];
        }
    }

    /**
     * Método que obtiene los turnos del médico para una determinada fecha
     * @param type $fecha
     * @return type
     */
    public function getTurnosDiaMedico($fecha = null) {
        //Si día es null, entonces es por el día de hoy
        if (is_null($fecha)) {
            $fecha = $this->sqlDate(date("d/m/Y"), '-', true);
        } else {
            list($m, $d, $y) = preg_split("[/]", $fecha);
            $fecha = $this->sqlDate(date("d/m/Y", mktime(0, 0, 0, $m, $d, $y)), '-', true);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("((
                            SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio, p.idpaciente, mv.motivoVisita, p.usuarioweb_idusuarioweb, u.nombre, u.apellido
                            FROM turno t 
                                    INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 

                            ) UNION

                            (
                            SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio, p.idpaciente, mv.motivoVisita, p.usuarioweb_idusuarioweb, pf.nombre, pf.apellido
                            FROM turno t 
                                    INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)

                            )) as t");

        $query->setWhere("medico_idmedico = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
        $query->addAnd("idpaciente IS NOT NULL");
        $query->addAnd("fecha = '$fecha'");
        $query->addAnd("t.estado = 1");
        $query->addAnd("t.anulado = 0");
        $query->addAnd("t.asistenciaPaciente IS NULL");

        $query->setOrderBy("horarioInicio");
        return $this->getList($query);
    }

    /**
     * Obtiene los siguientes turnos de los pacientes ordenado por las fechas más recientes
     * @param type $idpaciente
     * @param type $cantidad_turnos: Es la cantidad de turnos que se quieren obtener en el listado.
     * @return type
     */
    public function getSiguientesTurnosPaciente($idpaciente, $cantidad_turnos = 1) {



        $query = new AbstractSql();

        $query->setSelect("t.idturno, t.fecha, t.horarioInicio, uw.nombre, uw.apellido, mv.motivoVisita");

        $query->setFrom("$this->table t "
                . "INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita)"
                . "INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)"
                . "INNER JOIN usuarioweb uw ON (uw.idusuarioweb = m.usuarioweb_idusuarioweb)");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");
        $query->addAnd("(t.estado <= 1)");
        $query->addAnd("t.anulado = 0");
        $query->addAnd("t.asistenciaPaciente IS NULL");
        $hoy = date("Y-m-d");
        $query->addAnd("CONCAT(t.fecha,' ',t.horarioInicio) >= SYSDATE()");

        $query->setLimit("0, $cantidad_turnos");
        $query->setOrderBy("t.fecha DESC");

        return $this->getList($query);
    }

    /**
     * Obtiene los siguientes turnos de los pacientes ordenado por las fechas más recientes
     * @param type $request
     * @param type $idpaginate : Es la cantidad de turnos que se quieren obtener en el listado.
     * @return type
     */
    public function getListSiguientesTurnosPaciente($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 10, true);
        }

        $query = new AbstractSql();
        $hoy = date("Y-m-d");
        $now = date("H:i:s");
        $query->setSelect("t.$this->id, t.fecha, t.horarioInicio, m.idmedico, IFNULL(mv.motivoVisita,mvc.motivoVideoConsulta) as motivoVisita, c.nombreConsultorio, c.is_virtual,t.estado,"
                . "IF(t.fecha='$hoy' AND Time(t.horarioInicio)<=Time('$now'),1,0) as pasado");

        $query->setFrom("$this->table t 
                            
                            INNER JOIN medico m ON (t.medico_idmedico = m.idmedico) 
                            INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)
                            LEFT JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita)
                            LEFT JOIN motivovideoconsulta mvc ON(mvc.idmotivoVideoConsulta=t.motivoVideoConsulta_idmotivoVideoConsulta)
                           
                            ");


        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : 0;

        $query->setWhere("t.paciente_idpaciente = $idpaciente");
        $query->addAnd("t.estado = 1 || t.estado =0");



        $query->addAnd("CONCAT(t.fecha,' ',t.horarioInicio) >= SYSDATE()");

        $query->setOrderBy("t.fecha ASC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado && count($listado["rows"]) > 0) {

            $ManagerMedico = $this->getManager("ManagerMedico");

            foreach ($listado["rows"] as $key => $turno) {

                $listado["rows"][$key]["medico"] = $ManagerMedico->get($turno["idmedico"], true);
                $listado["rows"][$key]["medico"]["imagen"] = $ManagerMedico->getImagenMedico($turno["idmedico"]);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Obtiene el turno del paciente...
     * @param type $idturno
     * @return type
     */
    public function getTurnoPaciente($idturno) {



        $query = new AbstractSql();

        $query->setSelect("t.$this->id, t.fecha, t.horarioInicio, uw.nombre, t.paciente_idpaciente, pgf.pacienteTitular,uw.apellido, mv.motivoVisita, c.idconsultorio,c.nombreConsultorio, d.lat, d.lng, e.especialidad, s.subEspecialidad, tp.titulo_profesional,
                    t.estado");

        $query->setFrom("$this->table t 
                            INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                            INNER JOIN medico m ON (t.medico_idmedico = m.idmedico) 
                            INNER JOIN usuarioweb uw ON (uw.idusuarioweb = m.usuarioweb_idusuarioweb) 
                            INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio) 
                            LEFT JOIN pacientegrupofamiliar pgf ON (pgf.pacienteGrupo = t.paciente_idpaciente)
                            LEFT JOIN titulo_profesional tp ON (tp.idtitulo_profesional = m.titulo_profesional_idtitulo_profesional)
                            LEFT JOIN direccion d ON (d.iddireccion = c.direccion_iddireccion)
                            LEFT JOIN especialidadmedico em ON (em.medico_idmedico = m.idmedico)
                            LEFT JOIN especialidad e ON (em.especialidad_idespecialidad = e.idespecialidad)
                            LEFT JOIN subespecialidad s ON (em.subEspecialidad_idsubEspecialidad = s.idsubEspecialidad)");

        $query->setWhere("t.$this->id = $idturno");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            $turno = $execute->FetchRow();
            if ($turno) {
                $turno["numeroTurno"] = str_pad($turno[$this->id], 10, "0", STR_PAD_LEFT);

                //Corroboro que el turno elegido sea del paciente o de alguno de los pacientes
                $idpaciente_titular = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];

                if ($idpaciente_titular == $turno["paciente_idpaciente"] || $turno["pacienteTitular"] == $idpaciente_titular) {
                    return $turno;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public function getTurnosSemanaMedico($fecha = null) {
        //Si día es null, entonces es por el día de hoy
        if (is_null($fecha)) {
            $fecha = $this->sqlDate(date("d/m/Y"));
        } else {
            $fecha = $this->sqlDate($fecha);
        }

        $query = new AbstractSql();
        $query->setSelect("*");

        $query->setFrom("((
                            SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio, p.idpaciente, mv.motivoVisita, p.usuarioweb_idusuarioweb, u.nombre, u.apellido
                            FROM turno t 
                                    INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb) 

                            ) UNION

                            (
                            SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio, p.idpaciente, mv.motivoVisita, p.usuarioweb_idusuarioweb, pf.nombre, pf.apellido
                            FROM turno t 
                                    INNER JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)

                            )) as t");

        $query->setWhere("medico_idmedico = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
        $query->addAnd("fecha BETWEEN  DATE_SUB('$fecha',INTERVAL (DAYOFWEEK('$fecha')-2) DAY ) AND DATE_ADD('$fecha',INTERVAL (8-DAYOFWEEK('$fecha')) DAY)");
        $query->addAnd("t.idpaciente IS NOT NULL");
        //$query->addAnd("fecha = '$fecha'");
        $query->addAnd("t.estado = 1");
        $query->addAnd("t.anulado = 0");
        $query->addAnd("t.asistenciaPaciente IS NULL");
        $query->setOrderBy("horarioInicio");
        $turnos = $this->getList($query);
        return $turnos;
    }

    /**
     * Método que retorna el próximo turno disponible del médico
     * @param type $fecha: d/m/Y
     * @return int
     */
    public function getNextTurnoDisponble($idmedico, $fecha = null, $idconsultorio = null) {
        //Obtengo la configuración de la agenda para el médico
        $query = new AbstractSql();
        $query->setSelect("t.*,c.*");
        $query->setFrom("$this->table t INNER JOIN consultorio c ON (c.idconsultorio = t.consultorio_idconsultorio)");
        $query->setWhere("t.medico_idmedico = $idmedico");
        //$query->addAnd("t.dia_iddia = $dia_iddia");


        if (!is_null($idconsultorio) && (int) $idconsultorio > 0) {
            $query->setWhere("t.consultorio_idconsultorio = $idconsultorio");
        }

        $query->addAnd("t.paciente_idpaciente IS NULL");


        $query->addAnd("c.flag = 1");
//          $query->addAnd("c.is_virtual = 0");

        if (is_null($fecha)) {
            $fecha_format = $this->sqlDate(date("d/m/Y"));
        } else {
            $fecha_format = $this->sqlDate($fecha);
        }


        $query->addAnd("t.fecha >= '$fecha_format'");

        $horario_inicio = date("H:i:s");
        $query->addAnd("TIMESTAMP(t.fecha, t.horarioInicio) > '$fecha_format $horario_inicio'");

        //verifico que no traiga un turno del pasado
        $query->addAnd("TIMESTAMP(t.fecha, t.horarioInicio) > now()");
        //verififcamos si el medico tiene cargadas vacaciones, omitimos ese periodo
        $vacaciones_medico = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones($idmedico);

        foreach ($vacaciones_medico as $periodo_vacaciones) {
            $query->addAnd("fecha NOT BETWEEN '{$periodo_vacaciones["desde"]}' and '{$periodo_vacaciones["hasta"]}'");
        }
        $query->setOrderBy("t.fecha ASC");
        $query->setLimit("0,1");

        $rdo = $this
                ->db
                ->GetRow($query->getSql());


        if ($rdo) {

            return $rdo;
        } else {
            return false;
        }
    }

    /*     * Metodo que devuelve los siguientes turnos que tiene un paciente con un medico
     * 
     * @param type $idpaciente
     * @param type $idmedico
     */

    public function getNextTurnoPaciente($idpaciente, $idmedico) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("{$this->table} t");
        $query->setWhere("paciente_idpaciente=$idpaciente and medico_idmedico=$idmedico and TIMESTAMP(t.fecha, t.horarioInicio) > now() and (t.estado =1 OR  t.estado =0)");
        $turnos = $this->getList($query);

        return $turnos;
    }

    /*     * Metodo que devuleve los horarios para una fecha de turno de videoconsulta de un medico
     * 
     * @param type $idpaciente
     * @param type $idmedico
     */

    public function getComboHorariosTurnoVideConsulta($request) {

        //CONCAT(SUBSTRING(horarioInicio,1,5),'hs.'),idturno from turno WHERE fecha='2018-05-10' and estado =0 and paciente_idpaciente is null and consultorio_idconsultorio=113
        $consultorio_virtual = $this->getManager("ManagerConsultorio")->getByFieldArray(["medico_idmedico", "is_virtual"], [$request["medico_idmedico"], 1]);
        if (!$consultorio_virtual) {
            return false;
        }
        $query = new AbstractSql();
        $query->setSelect("idturno,CONCAT(SUBSTRING(horarioInicio,1,5),'hs.')");
        $query->setFrom("$this->table");
        $query->setWhere("fecha='{$request["fecha"]}' and estado =0 and paciente_idpaciente is null and consultorio_idconsultorio={$consultorio_virtual["idconsultorio"]}");

        return $this->getComboBox($query, false);
    }

    /*     * Metodo que devuleve las fechas de los proximos turnos de videoconsulta de un medico
     * 
     * @param type $idmedico
     * @return boolean
     */

    public function getComboFechasTurnoVideoConsulta($idmedico) {

        $consultorio_virtual = $this->getManager("ManagerConsultorio")->getByFieldArray(["medico_idmedico", "is_virtual"], [$idmedico, 1]);
        if (!$consultorio_virtual) {
            return false;
        }
        $query = new AbstractSql();
        $query->setSelect("fecha,CONCAT ((ELT(WEEKDAY(fecha) + 1, 'Lun', 'Mar', 'Mier', 'Jue', 'Vie', 'Sab', 'Dom')),'  ',DATE_FORMAT(fecha, '%d/%m/%Y'))");
        $query->setFrom("$this->table");
        $query->setWhere("CONCAT(fecha,' ',horarioInicio) > SYSDATE() and estado =0 and paciente_idpaciente is null and consultorio_idconsultorio={$consultorio_virtual["idconsultorio"]}");
        $query->setGroupBy("fecha");
        return $this->getComboBox($query, false);
    }

    /**
     * Método que retorna la cantidad de turnos disponibles que tiene un médico en un día
     * @param type $fecha : d/m/Y
     * @return int
     */
    public function getCantidadTurnosDisponblePorDia($fecha = null) {


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        //Obtengo la configuración de la agenda para el médico
        $query = new AbstractSql();

        $query->setSelect("COUNT(t.$this->id) as cantidad");

        $query->setFrom("$this->table t INNER JOIN consultorio c ON (c.idconsultorio = t.consultorio_idconsultorio)");

        $query->setWhere("t.medico_idmedico = $idmedico");
        //$query->addAnd("t.dia_iddia = $dia_iddia");
        $query->addAnd("t.paciente_idpaciente IS NULL");

//          $query->addAnd("c.is_virtual = 0");

        $query->addAnd("c.flag = 1");

        if (is_null($fecha)) {
            $fecha_format = $this->sqlDate(date("d/m/Y"));
        } else {
            $fecha_format = $this->sqlDate($fecha);
        }


        $query->addAnd("t.fecha = '$fecha_format'");
        $rdo = $this
                ->db
                ->Execute($query->getSql())
                ->FetchRow();

        if ($rdo != false) {
            return (int) $rdo["cantidad"];
        } else {
            return 0;
        }
    }

    /**
     * Obtiene un listado en formato JSON de los turnos y para mostrar en la agenda de prestadores
     * @param type $request
     * @return type
     */
    public function getAgendaTurnosJSON($request) {

        //Si día es null, entonces es por el día de hoy

        $fecha = $this->sqlDate(date("d/m/Y"));

        //Obtengo los días de la semana entre que y que voy a meter los turnos.. 
        // Tiene que ser de lunes x 5
        list($y, $m, $d) = preg_split("[-]", $fecha);
        $query = new AbstractSql();

        $query->setSelect("idturno as id, 
            CASE estado
            WHEN 0 THEN 'bg-green-2 text-center'
            WHEN 1 THEN 'bg-orange-4 text-center'
            WHEN 3 THEN 'bg-red-1 text-center'
            WHEN 5 THEN 'bg-red-1 text-center'
            END as className, 
            CONCAT(SUBSTRING(horarioInicio FROM 1 FOR 5),'hs. - ',SUBSTRING(horarioFin FROM 1 FOR 5),'hs.') as title,CONCAT(fecha,'T',horarioInicio) as start,CONCAT(fecha,'T',horarioFin) as end, fecha,nombre, apellido, idconsultorio, idpaciente,color, motivoVisita, estado,perfilSaludConsulta_idperfilSaludConsulta,configuracion_agenda_idconfiguracion_agenda ");

        $query->setFrom("(
                            (
                                    SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio,t.horarioFin, p.idpaciente, p.usuarioweb_idusuarioweb, u.nombre, u.apellido, c.idconsultorio, ifnull(mv.motivoVisita,mvc.motivoVideoConsulta) as motivoVisita, c.color, c.is_virtual, c.flag,t.perfilSaludConsulta_idperfilSaludConsulta,t.configuracion_agenda_idconfiguracion_agenda
                                    FROM turno t 
                                                    LEFT JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita) 
                                                    LEFT JOIN motivovideoconsulta mvc ON (t.motivoVideoConsulta_idmotivoVideoConsulta = mvc.idmotivoVideoConsulta)
                                                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                                    INNER JOIN usuarioweb u ON (p.usuarioweb_idusuarioweb = u.idusuarioweb)
                                                    INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)
                            )
                            UNION
                            (
                                    SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio,t.horarioFin, p.idpaciente, p.usuarioweb_idusuarioweb, pf.nombre, pf.apellido, c.idconsultorio, ifnull(mv.motivoVisita,mvc.motivoVideoConsulta) as motivoVisita, c.color, c.is_virtual, c.flag,t.perfilSaludConsulta_idperfilSaludConsulta,t.configuracion_agenda_idconfiguracion_agenda
                                    FROM turno t 
                                                    LEFT JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita)
                                                    LEFT JOIN motivovideoconsulta mvc ON (t.motivoVideoConsulta_idmotivoVideoConsulta = mvc.idmotivoVideoConsulta)
				                    INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente) 
                                                    INNER JOIN pacientegrupofamiliar pf ON (p.idpaciente = pf.pacienteGrupo)
                                                    INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)
                            )
                            UNION
                            (
                                    SELECT t.idturno,t.medico_idmedico, t.anulado,t.asistenciaPaciente, t.estado, t.fecha, t.horarioInicio,t.horarioFin, '' as idpaciente, '' as usuarioweb_idusuarioweb, '' as nombre, '' as apellido, c.idconsultorio, '' as motivoVisita, c.color, c.is_virtual, c.flag, t.perfilSaludConsulta_idperfilSaludConsulta,t.configuracion_agenda_idconfiguracion_agenda
                                    FROM turno t 
                                                    INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)
                                    WHERE t.paciente_idpaciente IS NULL
                            )
                    ) as t");

        $query->setWhere("medico_idmedico = " . $request["idmedico"]);
        if (!is_null($request["idconsultorio"])) {
            $query->addAnd("idconsultorio = {$request["idconsultorio"]}");
        }
        $query->addAnd("(t.configuracion_agenda_idconfiguracion_agenda is not null)");
        $query->addAnd("t.fecha BETWEEN '{$request["fecha_desde"]}' AND '{$request["fecha_hasta"]}'");
        $hoy = date("Y-m-d");
        $now = date("H:i:s");

        $query->addAnd("(t.fecha > '$hoy' OR (t.fecha='$hoy' AND Time(t.horarioInicio)>Time('$now')))");



        $query->addAnd("t.flag = 1");



        $turnos = $this->getList($query, false);



        return json_encode($turnos);
    }

    /**
     * Obtiene la agenda semanal del médico.
     * Tanto los turnos como todo lo otro
     * @param type $fecha_ Formato de la fecha a recibir "d/m/Y"
     * @return type
     */
    public function getAgendaDiaMedico($fecha = null, $idconsultorio = null) {

        //Si día es null, entonces es por el día de hoy
        if (is_null($fecha)) {
            $fecha = $this->sqlDate(date("d/m/Y"));
        } else {
            $fecha = $this->sqlDate($fecha);
        }
        //Obtengo los días de la semana entre que y que voy a meter los turnos.. 
        // Tiene que ser de lunes x 5
        list($y, $m, $d) = preg_split("[-]", $fecha);
        $query = new AbstractSql();

        $query->setSelect("idturno, horarioInicio,horarioFin, fecha,nombre, apellido, idconsultorio, idpaciente,color, motivoVisita, estado,perfilSaludConsulta_idperfilSaludConsulta,configuracion_agenda_idconfiguracion_agenda,estadoVideoConsulta_idestadoVideoConsulta ");
        $query->setFrom("(
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			p.idpaciente,
			p.usuarioweb_idusuarioweb,
			u.nombre,
			u.apellido,
			c.idconsultorio,
			ifnull( mv.motivoVisita, mvc.motivoVideoConsulta ) AS motivoVisita,
			c.color,
			c.is_virtual,
			c.flag,
			IFNULL( t.perfilSaludConsulta_idperfilSaludConsulta, psc.idperfilSaludConsulta ) AS perfilSaludConsulta_idperfilSaludConsulta,
			t.configuracion_agenda_idconfiguracion_agenda,
                        v.estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			LEFT JOIN motivovisita mv ON ( t.motivovisita_idmotivoVisita = mv.idmotivoVisita )
			LEFT JOIN motivovideoconsulta mvc ON ( t.motivoVideoConsulta_idmotivoVideoConsulta = mvc.idmotivoVideoConsulta )
			INNER JOIN paciente p ON ( t.paciente_idpaciente = p.idpaciente )
			INNER JOIN usuarioweb u ON ( p.usuarioweb_idusuarioweb = u.idusuarioweb )
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio )
			LEFT JOIN videoconsulta v ON ( v.turno_idturno = t.idturno )
			LEFT JOIN perfilsaludconsulta psc ON ( psc.videoconsulta_idvideoconsulta = v.idvideoconsulta AND psc.is_cerrado=1 ) 
		) UNION
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			p.idpaciente,
			p.usuarioweb_idusuarioweb,
			pf.nombre,
			pf.apellido,
			c.idconsultorio,
			ifnull( mv.motivoVisita, mvc.motivoVideoConsulta ) AS motivoVisita,
			c.color,
			c.is_virtual,
			c.flag,
			IFNULL( t.perfilSaludConsulta_idperfilSaludConsulta, psc.idperfilSaludConsulta ) AS perfilSaludConsulta_idperfilSaludConsulta,
			t.configuracion_agenda_idconfiguracion_agenda,
                        v.estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			LEFT JOIN motivovisita mv ON ( t.motivovisita_idmotivoVisita = mv.idmotivoVisita )
			LEFT JOIN motivovideoconsulta mvc ON ( t.motivoVideoConsulta_idmotivoVideoConsulta = mvc.idmotivoVideoConsulta )
			INNER JOIN paciente p ON ( t.paciente_idpaciente = p.idpaciente )
			INNER JOIN pacientegrupofamiliar pf ON ( p.idpaciente = pf.pacienteGrupo )
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio )
			LEFT JOIN videoconsulta v ON ( v.turno_idturno = t.idturno )
			LEFT JOIN perfilsaludconsulta psc ON ( psc.videoconsulta_idvideoconsulta = v.idvideoconsulta AND psc.is_cerrado=1 ) 
		) UNION
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			'' AS idpaciente,
			'' AS usuarioweb_idusuarioweb,
			'' AS nombre,
			'' AS apellido,
			c.idconsultorio,
			'' AS motivoVisita,
			c.color,
			c.is_virtual,
			c.flag,
			t.perfilSaludConsulta_idperfilSaludConsulta,
			t.configuracion_agenda_idconfiguracion_agenda,
                        '' as estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio ) 
		WHERE
			t.paciente_idpaciente IS NULL 
		) 
	) AS t ");

        $query->setWhere("medico_idmedico = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

        $query->addAnd("(t.configuracion_agenda_idconfiguracion_agenda is not null)");
        $query->addAnd("t.fecha = '$fecha'");

//          $query->addAnd("t.is_virtual = 0");

        $query->addAnd("t.flag = 1");

        if (!is_null($idconsultorio)) {
            $query->addAnd("idconsultorio = $idconsultorio");
        }
        $query->setGroupBy("horarioInicio");

        $query->setOrderBy("horarioInicio ASC");

        $listado = $this->getList($query);

        if ($listado && count($listado)) {
            //array que guarda la posicion en el listado de turnos, donde cambia de una config agenda a otra
            $posicion_cambio_config_agenda = [];
            $configuracion_agenda = [];
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");


            foreach ($listado as $key => $turno) {

                list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
                // Obtenemos el día de la semana de la fecha dada 
                $dia = date("w", mktime(0, 0, 0, $m, $d, $y));
                $listado[$key]["fecha_format"] = getNombreCortoDia($dia) . " " . fechaToString($turno["fecha"]);

                //verificamos si ya paso la fecha del turno, habilitamos la opcion de poner ausente al paciente

                if (strtotime($turno["fecha"] . " " . $turno["horarioInicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                    $listado[$key]["turno_pasado"] = 1;
                }

                //obtenemos la info del paciente
                if ($turno["idpaciente"] != "") {
                    $listado[$key]["paciente_imagen"] = $ManagerPaciente->getImagenPaciente($turno["idpaciente"]);
                }
                //marcamos si es el turno actual
                //verificamos la fecha de hoy
                if (strtotime($turno["fecha"]) == strtotime(date("Y-m-d"))) {
                    //verificamos que la hora actual este en el rango de la duracion del turno
                    $inicio = strtotime($turno["fecha"] . " " . $turno["horarioInicio"]);
                    $fin = strtotime($turno["fecha"] . " " . $turno["horarioFin"]);
                    $actual = strtotime(date("Y-m-d H:i:s"));
                    if ($inicio < $actual && $actual < $fin) {
                        $listado[$key]["turno_actual"] = 1;
                    }
                }

                //verificamos la config agenda para ver si hay tiempo libre entre turnos
                //en la primer iteracion almacenamos la config agenda de los turnos para comparar los horarios si hay otra config
                if ($key == 0) {

                    $configuracion_agenda = $ManagerConfiguracionAgenda->get($turno["configuracion_agenda_idconfiguracion_agenda"]);
                } elseif ($configuracion_agenda["idconfiguracionAgenda"] != $turno["configuracion_agenda_idconfiguracion_agenda"]) {
                    //si cambia la configuracion agenda, obtenemos los nueva y comparamos los horarios
                    $config_agenda_aux = $ManagerConfiguracionAgenda->get($turno["configuracion_agenda_idconfiguracion_agenda"]);
                    if (strtotime($turno["fecha"] . " " . $configuracion_agenda["hasta"]) < strtotime($turno["fecha"] . " " . $config_agenda_aux["desde"])) {

                        //almacenamos la posicion donde cambia la configuracion de agenda, con el horario libre entre cada una
                        //almacenamos el fin de la primer config agenda, y el comienzo de la que sigue
                        $posicion_cambio_config_agenda[$key] = array("desde" => $configuracion_agenda["hasta"], "hasta" => $config_agenda_aux["desde"]);

                        //actualmizamos la variable de config agenda con la actual, para seguri comparando si hay mas cambios de config agenda
                        $configuracion_agenda = $config_agenda_aux;
                    }
                }
            }
            //si hay un cambio de la configuracion de agenda puede haber break de tiempo libre
            if (count($posicion_cambio_config_agenda) > 0) {
                $listado["posicion_cambio_config_agenda"] = $posicion_cambio_config_agenda;
            }
        }

        return $listado;
    }

    /**
     * Obtiene la agenda semanal del médico.
     * Tanto los turnos como todo lo otro
     * @param type $fecha_ Formato de la fecha a recibir "d/m/Y"
     * @return type
     */
    public function getAgendaSemanaMedico($fecha = null, $idconsultorio = null) {
        //Si día es null, entonces es por el día de hoy

        list($d, $m, $y) = preg_split("[/]", $fecha);
        $dia_semana = date('w', mktime(0, 0, 0, $m, $d, $y));

        if ($dia_semana == 1) {
            $fecha_inicio_semana = date('Y-m-d', mktime(0, 0, 0, $m, $d, $y));
        } else {
            $fecha_inicio_semana = date('Y-m-d', strtotime('previous Monday', mktime(0, 0, 0, $m, $d, $y)));
        }
        $fecha_fin_semana = date('Y-m-d', strtotime('Sunday', mktime(0, 0, 0, $m, $d, $y)));

        $query = new AbstractSql();

        $query->setSelect("idturno, horarioInicio,horarioFin, fecha,nombre, apellido, idconsultorio, idpaciente,color, estado,perfilSaludConsulta_idperfilSaludConsulta,configuracion_agenda_idconfiguracion_agenda,estadoVideoConsulta_idestadoVideoConsulta ");
        $query->setFrom("(
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			p.idpaciente,
			p.usuarioweb_idusuarioweb,
			u.nombre,
			u.apellido,
			c.idconsultorio,
			c.color,
			c.is_virtual,
			IFNULL( t.perfilSaludConsulta_idperfilSaludConsulta, psc.idperfilSaludConsulta ) AS perfilSaludConsulta_idperfilSaludConsulta,
			configuracion_agenda_idconfiguracion_agenda,
                        v.estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			INNER JOIN paciente p ON ( t.paciente_idpaciente = p.idpaciente )
			INNER JOIN usuarioweb u ON ( p.usuarioweb_idusuarioweb = u.idusuarioweb )
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio )
			LEFT JOIN videoconsulta v ON ( v.turno_idturno = t.idturno )
			LEFT JOIN perfilsaludconsulta psc ON ( psc.videoconsulta_idvideoconsulta = v.idvideoconsulta AND psc.is_cerrado=1 ) 
		) UNION
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			p.idpaciente,
			p.usuarioweb_idusuarioweb,
			pf.nombre,
			pf.apellido,
			c.idconsultorio,
			c.color,
			c.is_virtual,
			IFNULL( t.perfilSaludConsulta_idperfilSaludConsulta, psc.idperfilSaludConsulta ) AS perfilSaludConsulta_idperfilSaludConsulta,
			configuracion_agenda_idconfiguracion_agenda,
                        v.estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			INNER JOIN paciente p ON ( t.paciente_idpaciente = p.idpaciente )
			INNER JOIN pacientegrupofamiliar pf ON ( p.idpaciente = pf.pacienteGrupo )
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio )
			LEFT JOIN videoconsulta v ON ( v.turno_idturno = t.idturno )
			LEFT JOIN perfilsaludconsulta psc ON ( psc.videoconsulta_idvideoconsulta = v.idvideoconsulta AND psc.is_cerrado=1) 
		) UNION
		(
		SELECT
			t.idturno,
			t.medico_idmedico,
			t.anulado,
			t.asistenciaPaciente,
			t.estado,
			t.fecha,
			t.horarioInicio,
			t.horarioFin,
			'' AS idpaciente,
			'' AS usuarioweb_idusuarioweb,
			'' AS nombre,
			'' AS apellido,
			c.idconsultorio,
			c.color,
			c.is_virtual,
			t.perfilSaludConsulta_idperfilSaludConsulta,
			configuracion_agenda_idconfiguracion_agenda,
                        '' as estadoVideoConsulta_idestadoVideoConsulta
		FROM
			turno t
			INNER JOIN consultorio c ON ( t.consultorio_idconsultorio = c.idconsultorio ) 
		WHERE
			t.paciente_idpaciente IS NULL 
		) 
	) AS t ");

        $query->setWhere("medico_idmedico = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
        $query->addAnd("(t.fecha BETWEEN '$fecha_inicio_semana' AND '$fecha_fin_semana')");
        $query->addAnd("(t.configuracion_agenda_idconfiguracion_agenda is not null)");

        if (!is_null($idconsultorio)) {
            $query->addAnd("idconsultorio = $idconsultorio");
        }

//          $query->addAnd("t.is_virtual = 0");


        $query->setGroupBy("t.horarioInicio,t.fecha");
        $query->setOrderBy("fecha ASC, horarioInicio ASC");

        $list_temp = $this->getList($query);

        //Si hay listado temporal 
        if ($list_temp && count($list_temp)) {
            $listado = [];
            for ($i = 1; $i <= 7; $i++) {
                $listado[$i] = [];
            }
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            //Armo un array: $listado["dia"][]["turno"]
            //verififcamos si el medico tiene cargadas vacaciones, omitimos ese periodo
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $vacaciones_medico = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones($idmedico);
            foreach ($vacaciones_medico as $periodo_vacaciones) {
                $query->addAnd("fecha NOT BETWEEN '{$periodo_vacaciones["desde"]}' and '{$periodo_vacaciones["hasta"]}'");
            }
            foreach ($list_temp as $key => $turno) {

                list($y, $m, $d) = preg_split("[-]", $turno["fecha"]);
                // Obtenemos el día de la semana de la fecha dada 
                $dia = date("w", mktime(0, 0, 0, $m, $d, $y));
                $turno["fecha_format"] = getNombreCortoDia($dia) . " " . fechaToString($turno["fecha"]);

                //verificamos si ya paso la fecha del turno, habilitamos la opcion de poner ausente al paciente

                if (strtotime($turno["fecha"] . " " . $turno["horarioInicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                    $turno["turno_pasado"] = 1;
                }

                //marcamos si es el turno actual
                //verificamos la fecha de hoy
                if (strtotime($turno["fecha"]) == strtotime(date("Y-m-d"))) {
                    //verificamos que la hora actual este en el rango de la duracion del turno
                    $inicio = strtotime($turno["fecha"] . " " . $turno["horarioInicio"]);
                    $fin = strtotime($turno["fecha"] . " " . $turno["horarioFin"]);
                    $actual = strtotime(date("Y-m-d H:i:s"));
                    if ($inicio < $actual && $actual < $fin) {
                        $turno["turno_actual"] = 1;
                    }
                }
                if ($turno["idpaciente"] != "") {
                    $turno["paciente_imagen"] = $ManagerPaciente->getImagenPaciente($turno["idpaciente"]);
                }
                //veriifamos si el turno esta en el periodo de vacaciones cargado por el medico
                if ($vacaciones_medico) {
                    foreach ($vacaciones_medico as $periodo_vacaciones) {
                        if (strtotime($turno["fecha"]) >= strtotime($periodo_vacaciones["desde"]) && strtotime($turno["fecha"]) <= strtotime($periodo_vacaciones["hasta"])) {
                            $turno["vacaciones"] = 1;
                            break;
                        }
                    }
                }
                $listado[(int) $dia][] = $turno;
            }

            return $listado;
        } else {
            return false;
        }
    }

    /*     * Obtiene los turnos del mes del medico
     * 
     * @param type $fecha
     * @param type $idconsultorio
     * @return boolean
     */

    public function getAgendaMensualMedico($fecha = NULL, $idconsultorio = NULL) {

        //Si día es null, entonces es por el día de hoy
        if (is_null($fecha)) {
            $fecha = $this->sqlDate(date("d/m/Y"));
        } else {
            $fecha = $this->sqlDate($fecha);
        }

        //Obtengo los días de la semana entre que y que voy a meter los turnos.. 
        // Tiene que ser de lunes x 5
        list($y, $m, $d) = preg_split("[-]", $fecha);
        $fecha_test = date("Y-m-d", strtotime("last Monday", mktime(0, 0, 0, $m, 1, $y)));
        $fecha_mes_actual = $m;
        $fecha_test_fin = date("Y-m-d", strtotime("next Sunday", mktime(0, 0, 0, $m + 1, 1, $y)));


        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query = new AbstractSql();
        $query->setSelect("T.fecha,
         DAYOFWEEK(T.fecha)-1 as dia_iddia,
         SUM(T.turno_disponible) as cant_disponibles,
         SUM(T.turno_pendiente) as cant_pendientes,
         SUM(T.turno_confirmado) as cant_confirmados");

        $query->setFrom("(SELECT 	
                                t.idturno,
                                t.fecha,
                                ca.dia_iddia,
                                t.estado,
                                IF (t.estado = 1 AND t.paciente_idpaciente IS NOT NULL,1,0) AS turno_confirmado,
                                IF (t.estado = 0 AND t.paciente_idpaciente IS NOT NULL,1,0) AS turno_pendiente,
                                IF (t.estado = 0 AND t.paciente_idpaciente IS NULL,1,0) AS turno_disponible
                        FROM turno t
                        INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)
                        INNER JOIN configuracionagenda ca ON (t.configuracion_agenda_idconfiguracion_agenda = ca.idconfiguracionAgenda)
			WHERE t.medico_idmedico = $idmedico 
                        AND t.fecha BETWEEN '$fecha_test' AND '$fecha_test_fin' AND c.flag = 1 
                        AND t.consultorio_idconsultorio=$idconsultorio
			GROUP BY t.fecha,t.horarioInicio) as T");




        $query->setGroupBy("T.fecha");
        $query->setOrderBy("T.fecha");

        $list_temp = $this->getList($query);

        if ($list_temp) {
            $array_new = array();
            $iterator = 0;
            for ($i = 0; $i < 6 * 7; $i++) {
                list($y, $m, $d) = preg_split("[-]", $fecha_test);
                $flag = 0;


                foreach ($list_temp as $key => $dia_agenda) {

                    if (strtotime($fecha_test) == strtotime($dia_agenda["fecha"])) {

                        $array_new[$iterator]["agenda"] = $dia_agenda;
                        $flag++;
                    }
                }
                if ($flag == 0) {
                    //agrgemos los dias que no hay turnos para completar el calendario
                    $dia = date("w", mktime(0, 0, 0, $m, $d, $y));
                    $array_new[$iterator]["agenda"]["dia_iddia"] = $dia;
                    $array_new[$iterator]["agenda"]["cant_confirmados"] = 0;
                    $array_new[$iterator]["agenda"]["cant_disponibles"] = 0;
                    $array_new[$iterator]["agenda"]["cant_pendientes"] = 0;
                    $array_new[$iterator]["agenda"]["fecha"] = $fecha_test;
                }

                //marcamos los turnos que peretneces al mes actual, el resto se visualiza como desativado
                if ($m == $fecha_mes_actual) {
                    $array_new[$iterator]["agenda"]["is_actual"] = true;
                } else {
                    $array_new[$iterator]["agenda"]["is_actual"] = false;
                }

                $fecha_test = date('Y-m-d', strtotime('+1 day', mktime(0, 0, 0, $m, $d, $y)));
                $iterator++;
            }
        }

        return $array_new;
    }

    /**
     * Método que realiza las inserciones de los turnos sin pacientes configurados, 
     * cada vez que se agrega una configuración de agenda. 
     * @param type $idconfiguracion_agenda
     * @return boolean
     */
    public function insertTurnoXConfiguracionAgenda($idconfiguracion_agenda) {


        $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
        $configuracion_agenda = $ManagerConfiguracionAgenda->get($idconfiguracion_agenda);

        list($fecha_an, $fecha_mn, $fecha_dn) = preg_split("[/]", date("Y/m/d"));

        $semana = date("W", mktime(0, 0, 0, $fecha_mn, $fecha_dn, $fecha_an));
        $primer_semana = date("W", mktime(0, 0, 0, $fecha_mn, 1, $fecha_an));

        $semana = $semana - $primer_semana - 1;


        //Obtengo la configuración de agenda del médico
        $ManagerPreferencia = $this->getManager("ManagerPreferencia");
        $preferencia_medico = $ManagerPreferencia->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
        $duracion_turno = (int) $preferencia_medico["duracionTurnos"];


        for ((int) $semana; $semana <= 4; $semana++) {
            $fecha_insert = date('Y-m-d', mktime(0, 0, 0, $fecha_mn, (1 + $semana * 7), $fecha_an));

            //Creacion de la fecha que va a ser el turno
            list($fecha_anio_insert, $fecha_mes_insert, $fecha_dia_insert) = preg_split("[-]", $fecha_insert);



            $horario_desde = "";
            do {
                if ($horario_desde == "") {
                    $horario_desde = $configuracion_agenda["desde"];
                } else {
                    $horario_desde = $horario_hasta;
                }

                $horario_hasta = $this->getRangoHorario($horario_desde, $duracion_turno);




                $dia_iddia = $configuracion_agenda["dia_iddia"];

                //Recorro todos los días de la semana
                for ($i = 1; $i < 8; $i++) {

                    if ($dia_iddia == $i) {




                        $fecha_turno = date('Y-m-d', mktime(0, 0, 0, $fecha_mes_insert, $fecha_dia_insert + $dia_iddia, $fecha_anio_insert));
                        list($fta, $ftm, $ftd) = preg_split("[-]", $fecha_turno);

                        if ($fecha_mn == $ftm && (int) $fecha_dn <= (int) $ftd) {
//fix para asegurarme que no inserto turnos los dias domingo
                            if (getNumeroDiaSemana($ftd, $ftm, $fta) != 6) {
                                $insert_turno = $this->insert(array(
                                    "medico_idmedico" => $configuracion_agenda["medico_idmedico"],
                                    "consultorio_idconsultorio" => $configuracion_agenda["consultorio_idconsultorio"],
                                    "servicio_medico_idservicio_medico" => $configuracion_agenda["servicio_medico_idservicio_medico"],
                                    "horarioInicio" => $horario_desde,
                                    "horarioFin" => $horario_hasta,
                                    "fecha" => $fecha_turno,
                                    "configuracion_agenda_idconfiguracion_agenda" => $idconfiguracion_agenda
                                ));
                            }
                        }
                    }
                }

                //echo "$horario_hasta : " . $configuracion["hasta"] . "<br />";
            } while ($horario_hasta != $configuracion_agenda["hasta"]);
        }
        return true;
    }

    /**
     * Elimina los turnos futuros que esten pendientes o confirmados pertencientes a una configuracion de agenda
     * @param type $idconfiguracion_agenda
     * @return boolean
     */
    public function deleteTurnoXConfiguracionAgenda($idconfiguracion_agenda) {

        $fecha_actual = date("Y-m-d");
        $hora_actual = date("H:i:s");

        //Elimino todos los turnos menos los que tengan el estado dos
        $rdo = $this->db->Execute("DELETE FROM $this->table WHERE "
                . " configuracion_agenda_idconfiguracion_agenda = $idconfiguracion_agenda "
                . " AND ((fecha>'$fecha_actual') OR (fecha='$fecha_actual' AND horarioInicio>='$hora_actual'))");

        if ($rdo) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  Obtiene un consultorio a partir de un horario de atencion y un médico
     *  formato de fecha y-m-d     
     *
     * */
    public function getConsultorioPorHorario($idmedico, $fecha, $horario) {


        list($y, $m, $d) = preg_split("[/]", $fecha);

        $fecha_format = $this->sqlDate(date("d/m/Y", mktime(0, 0, 0, $m, $d, $y)), '-', true);

        $consultorio = $this
                ->db
                ->Execute("
                                SELECT
                                    co.*
                                FROM 
                                    $this->table t
                                    JOIN v_consultorio co ON (t.consultorio_idconsultorio = co.idconsultorio)
                                    
                                WHERE
                                    t.medico_idmedico = $idmedico AND t.fecha = '$fecha_format' AND STR_TO_DATE('$horario','%H:%i') BETWEEN t.horarioInicio AND t.horarioFin
                            ")
                ->FetchRow();

        return $consultorio;
    }

    public function getTodosHorariosSinTurnoMedico($idmedico, $idconsultorio, $fecha) {

        $fecha_hoy = date("Y-m-d");
        $min = date("H:i:s");

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        $query->addAnd("consultorio_idconsultorio=$idconsultorio");
        $query->addAnd("paciente_idpaciente IS NULL and estado=0");
        $query->addAnd(" WEEK(fecha)=WEEK('$fecha')");
        $query->addAnd(" ((fecha > '$fecha_hoy')
                            OR 
                            (fecha = '$fecha_hoy' AND horarioInicio > '$min'))");
        //verififcamos si el medico tiene cargadas vacaciones, omitimos ese periodo
        $vacaciones_medico = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones($idmedico);
        foreach ($vacaciones_medico as $periodo_vacaciones) {
            $query->addAnd("fecha NOT BETWEEN '{$periodo_vacaciones["desde"]}' and '{$periodo_vacaciones["hasta"]}'");
        }

        $query->setGroupBy("fecha,horarioInicio");
        $query->setOrderBy("fecha ASC, horarioInicio ASC");


        return $this->getList($query);
    }

    /*     * *
     * Generación de los turnos para el próximo mes en base a la configuración de la agenda actual
     */

    public function generate_cron() {

        $this->db->StartTrans();
        //obtenemos la fecha actual en que se ejecuta el cron
        $fecha_actual = date("Y-m-d");
        //buscamos el mes siguiente para generar turnos futuros
        $fecha_mes_siguiente = date("Y-m-d", strtotime('+1 month', strtotime($fecha_actual)));


        list($anio_siguiente, $mes_siguiente, $dia_siguiente) = preg_split("[-]", $fecha_mes_siguiente);


        $ManagerMedicos = $this->getManager("ManagerMedico");
        //Obtengo todos los médicos activos
        $list_medicos = $ManagerMedicos->getListAllMedicos();


        if (count($list_medicos) > 0) {
            //Si hay médicos, me fijo la configuración de la agenda uno por uno y así creo los turnos de los médicos
            $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
            $ManagerConsultorio = $this->getManager("ManagerConsultorio");
            $ManagerPreferencia = $this->getManager("ManagerPreferencia");
            $ManagerTurno = $this->getManager("ManagerTurno");


            foreach ($list_medicos as $key => $medico) {
                //Obtengo el listado de consultorios del médico
                $listado_consultorio = $ManagerConsultorio->getListconsultorioMedico($medico["idmedico"]);



                if ($listado_consultorio != false) {
                    //Obtengo la configuración de agenda del médico
                    $preferencia_medico = $ManagerPreferencia->getPreferenciaMedico($medico["idmedico"]);
                    $duracion_turno = (int) $preferencia_medico["duracionTurnos"];



                    //Recorro todos los consultorios

                    foreach ($listado_consultorio as $key => $consultorio) {

                        //Por cada consultorio busco la configuración de agenda.
                        $listado_configuracion_agenda_consultorio = $ManagerConfiguracionAgenda->getTodosLosHorarios($medico["idmedico"], $consultorio["idconsultorio"]);


                        if ($listado_configuracion_agenda_consultorio != false) {
                            foreach ($listado_configuracion_agenda_consultorio as $key => $listado_configuracion_agenda) {


                                foreach ($listado_configuracion_agenda as $key => $configuracion) {
                                    $dias_mes = getCantidadDiasMes($mes_siguiente);
                                    for ($dia = 1; $dia <= $dias_mes; $dia++) {
                                        $fecha_insert = date('Y-m-d', mktime(0, 0, 0, $mes_siguiente, $dia, $anio_siguiente));
                                        //verificamos que ese dia de la semana haya una configuracion de agenda definida
                                        //restamos 1 dia porque la funcion getNumeroDiaSemana devuelve 0 para lunes y la configuracion de agenda utiliza 1 para lunes
                                        if (getNumeroDiaSemana($dia, $mes_siguiente, $anio_siguiente) == ($configuracion["dia_iddia"] - 1)) {
                                            //echo "<br>fecha:$fecha_insert - conf:{$configuracion["idconfiguracionAgenda"]} - dia:{$configuracion["dia_iddia"]}<br>";

                                            $horario_desde = "";
                                            do {
                                                if ($horario_desde == "") {
                                                    $horario_desde = $configuracion["desde"];
                                                } else {
                                                    $horario_desde = $horario_hasta;
                                                }
                                                $horario_hasta = $this->getRangoHorario($horario_desde, $duracion_turno);
                                                //verificamos que no se haya creado ya un turno es ese horario
                                                $exist = $this->getByFieldArray(["consultorio_idconsultorio", "fecha", "horarioInicio", "horarioFin"], [$consultorio["idconsultorio"], $fecha_insert, $horario_desde, $horario_hasta]);
                                                if (!$exist) {
                                                    $insert_turno = $ManagerTurno->insert(array(
                                                        "medico_idmedico" => $medico["idmedico"],
                                                        "consultorio_idconsultorio" => $consultorio["idconsultorio"],
                                                        "servicio_medico_idservicio_medico" => $configuracion["servicio_medico_idservicio_medico"],
                                                        "horarioInicio" => $horario_desde,
                                                        "horarioFin" => $horario_hasta,
                                                        "fecha" => $fecha_insert,
                                                        "configuracion_agenda_idconfiguracion_agenda" => $configuracion["idconfiguracionAgenda"]
                                                    ));
                                                    if (!$insert_turno) {
                                                        $this->db->FailTrans();
                                                        $this->db->CompleteTrans();
                                                        return false;
                                                    }
                                                }
                                            } while ($horario_hasta != $configuracion["hasta"]);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        $this->db->CompleteTrans();
    }

    private function getRangoHorario($desde, $duracion_turno) {

        list($hd, $md, $sd) = preg_split("[:]", $desde);

        //Cantidad de minutos más la duración de turnos
        (int) $cantidad_minutos = (int) $md + (int) $duracion_turno;


        //Si la cantidad de minutos es mayor que 60
        if ($cantidad_minutos >= 60) {
            //(int) $hd += (int) ceil($cantidad_minutos / 60);
            (int) $hd += 1;
            (int) $md += (int) $cantidad_minutos % 60;
        } else {
            (int) $mh += (int) $cantidad_minutos;
        }


        if ($hd == "0") {
            $string_hora = "00";
        } elseif (strlen($hd) == 1) {
            $string_hora = "0$hd";
        } else {
            $string_hora = "$hd";
        }

        if ((int) $mh == 0) {
            $string_minuto = "00";
        } elseif (strlen($mh) == 1) {
            $string_minuto = "0$mh";
        } else {
            $string_minuto = "$mh";
        }

        $re = $string_hora . ":" . $string_minuto . ":00";

        //echo "rs: $re <br />";
        return $re;
    }

    /**
     * OBtención del detalle de los turno en base al id de uno mismo
     * @param type $idturno
     * @return boolean
     */
    public function getDetalleTurno($idturno) {
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $query = new AbstractSql();

        $query->setSelect(" 
                        t.idturno,
                        t.estado,
                        t.comentario,
                        t.fecha,
                        t.horarioInicio, 
                        t.perfilSaludConsulta_idperfilSaludConsulta,
                        sm.idservicio_medico,
                        sm.servicio_medico,
                        mv.motivoVisita,
                        mvc.motivoVideoConsulta,
                        IFNULL(uw.sexo, pgf.sexo) as sexo,
                        IFNULL(uw.nombre, pgf.nombre) as nombre,
                        IFNULL(uw.apellido, pgf.apellido) as apellido,
                        p.fechaNacimiento,
                        p.idpaciente,
                        IFNULL(p.numeroCelular,titular.numeroCelular) as numeroCelular,
                        uw.email,
                        c.nombreConsultorio,
                        c.is_virtual,
                        os.nombre as nombre_os,
                        os.nombre as nombre_corto,
                        pos.nombrePlan,
                        osp.nroAfiliadoObraSocial
                      ");

        $query->setFrom("$this->table t"
                . " INNER JOIN paciente p ON (p.idpaciente = t.paciente_idpaciente)"
                . " INNER JOIN servicio_medico sm ON (t.servicio_medico_idservicio_medico = sm.idservicio_medico)"
                . " INNER JOIN consultorio c ON (t.consultorio_idconsultorio = c.idconsultorio)"
                . " LEFT JOIN motivovisita mv ON (t.motivovisita_idmotivoVisita = mv.idmotivoVisita)"
                . " LEFT JOIN motivovideoconsulta mvc ON (t.motivoVideoConsulta_idmotivoVideoConsulta = mvc.idmotivoVideoConsulta)"
                . " LEFT JOIN usuarioweb uw ON (p.usuarioweb_idusuarioweb = uw.idusuarioweb)"
                . " LEFT JOIN pacientegrupofamiliar pgf ON (p.idpaciente = pgf.pacienteGrupo)"
                . " LEFT JOIN obrasocialpaciente osp ON (p.idpaciente=osp.paciente_idpaciente)"
                . " LEFT JOIN obrasocial os ON (osp.obraSocial_idobraSocial = os.idobraSocial) "
                . " LEFT JOIN planobrasocial pos ON (pos.idplanObraSocial = osp.planObraSocial_idplanObraSocial) "
                . " LEFT JOIN paciente titular ON (pgf.pacienteTitular= titular.idpaciente)");

        $query->setWhere("t.medico_idmedico = $idmedico");
        $query->addAnd("t.idturno = $idturno");

        $rdo = $this->db->Execute($query->getSql())->FetchRow();

        if ($rdo) {
            $rdo["paciente_imagen"] = $this->getManager("ManagerPaciente")->getImagenPaciente($rdo["idpaciente"]);
            $rdo["mensaje_turno"] = $this->getManager("ManagerMensajeTurno")->getListadoMensajes($idturno, $rdo["idpaciente"]);
            return $rdo;
        } else {
            return false;
        }
    }

    /*     * Metodo que retorna el siguiente turno que tiene asignado un medico a partir de un turno dado
     * utilzado para el slider de la detalle de turno en la agenda del medico
     * 
     * @param type $idturno
     */

    public function getNextTurnoMedico($idturno) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $turnoActual = $this->get($idturno);
        $query = new AbstractSql();
        $query->setSelect("idturno");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        $query->addAnd("paciente_idpaciente is not NULL");
        $query->addAnd("idturno <> {$turnoActual["idturno"]}");
        $query->addAnd("(fecha = '{$turnoActual["fecha"]}' AND horarioInicio > '{$turnoActual["horarioInicio"]}') OR (fecha > '{$turnoActual["fecha"]}')");
        $query->setOrderBy("idturno ASC");
        $query->setLimit("0,1");
        $rdo = $this->db->getRow($query->getSql());
        return $rdo["idturno"];
    }

    /*     * Metodo que retorna el turno anterior que tiene asignado un medico a partir de un turno dado
     * utilzado para el slider de la detalle de turno en la agenda del medico
     * 
     * @param type $idturno
     */

    public function getPrevTurnoMedico($idturno) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $turnoActual = $this->get($idturno);
        $query = new AbstractSql();
        $query->setSelect("idturno");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico=$idmedico");
        $query->addAnd("paciente_idpaciente is not NULL");
        $query->addAnd("idturno <> {$turnoActual["idturno"]}");
        $query->addAnd("(fecha = '{$turnoActual["fecha"]}' AND horarioInicio < '{$turnoActual["horarioInicio"]}') OR (fecha < '{$turnoActual["fecha"]}')");
        $query->setOrderBy("idturno DESC");
        $query->setLimit("0,1");
        $rdo = $this->db->getRow($query->getSql());
        return $rdo["idturno"];
    }

    /**
     * Método para actualizar el estado del turno desde el medico
     * @param type $request
     * @param type $idturno
     * @return boolean
     */
    public function updateFromFrontendTurno($request, $idturno) {

        $turno_prev = $this->get($idturno);
        if (CONTROLLER != "medico") {
            $idmedico = $turno_prev["medico_idmedico"];
        } else {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }


        if ($request["autoconfirmar_turno"] == 1) {
            $idmedico = $request["medico_idmedico"];
        }
        if ($turno_prev["medico_idmedico"] != $idmedico) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el turno", "result" => false]);
            return false;
        }
        //verificamos si ya paso la fecha del turno, habilitamos la opcion de poner ausente al paciente    
        if (strtotime($turno_prev["fecha"] . " " . $turno_prev["horarioInicio"]) < strtotime(date("Y-m-d H:i:s")) && $request["estado"] != 5) {
            $this->setMsg(["msg" => "Error. El turno ya no se encuentra disponible", "result" => false]);
            return false;
        }

        //Si el turno es hoy, no enviamos el recordatorio extra, solo notificacion de confirmacion:
        if (date("Y-m-d") == $turno_prev["fecha"]) {
            $request["isEnvioRecordatorio"] = 2;
        }
        $this->db->StartTrans();
        $id = parent::update($request, $idturno);
        //Cuando el médico cambia el estado, genero una notificación para el paciente
        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        $record["idturno"] = $idturno;
        $record["estado"] = $request["estado"];
        $rdo_insert_notificacion = $ManagerNotificacion->createNotificacionFromCambioEstadoTurno($record);


        if ($id && $rdo_insert_notificacion) {

            $turno = $this->get($id);


            //si se confirma el turno inserto una videoconsulta si el consultorio es virtual
            if ($request["estado"] == 1) {

                $insert_mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $turno["medico_idmedico"], "paciente_idpaciente" => $turno["paciente_idpaciente"]]);
                if ($this->is_turno_videoconsulta($idturno)) {

                    // <-- LOG
                    $log["data"] = "date, time, patient, reason for consulting";
                    $log["page"] = "Notifications";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = "Confirm Video Consultation appointment";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    // 

                    $arr["paciente_idpaciente"] = $turno["paciente_idpaciente"];
                    $arr["medico_idmedico"] = $turno["medico_idmedico"];
                    $arr["turno_idturno"] = $turno["idturno"];
                    $arr["fecha_inicio"] = date("Y-m-d H:i:s");
                    $arr["inicio_sala"] = $turno["fecha"] . " " . $turno["horarioInicio"];
                    $arr["fecha_vencimiento"] = strtotime('+' . VIDEOCONSULTA_VENCIMIENTO_SALA . ' minutes', strtotime($arr["inicio_sala"]));
                    $arr["motivoVideoConsulta_idmotivoVideoConsulta"] = $turno["motivoVideoConsulta_idmotivoVideoConsulta"];
                    $arr["estadoVideoConsulta_idestadoVideoConsulta"] = 2;
                    $arr["tipo_consulta"] = 2;
                    $arr["beneficia_reintegro"] = $turno["beneficia_reintegro"];
                    $arr["grilla_idgrilla"] = $turno["grilla_idgrilla"];
                    $arr["grilla_excepcion_idgrilla_excepcion"] = $turno["grilla_excepcion_idgrilla_excepcion"];
                    $arr["idprograma_categoria"] = $turno["idprograma_categoria"];
                    //seteamos el precio de la videoconsulta
                    $idpacienteTitular = $this->getManager("ManagerPaciente")->getPacienteTitular($turno["paciente_idpaciente"])["idpaciente"];

                    $result_monto = $this->getManager("ManagerMovimientoCuenta")->getMontoVideoConsultaTurnoPaciente($idturno, $idpacienteTitular);

                    $monto = $result_monto["monto"];

                    if (!$result_monto) {
                        $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.",
                            "result" => false
                        ]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                    //marcamos si la consulta de cobró en dinero o debito consultas disponibles del plan empresa
                    $arr["debito_plan_empresa"] = $result_monto["debito_plan_empresa"];

                    //verificamos si el turno de VC se saco mediante prestador
                    if ($turno["prestador_idprestador"] != "") {
                        $arr["prestador_idprestador"] = $turno["prestador_idprestador"];
                        $arr["precio_tarifa_prestador"] = $monto;
                        $arr["precio_tarifa"] = 0;
                    } else {
                        $arr["precio_tarifa"] = $monto;
                    }


                    $videoconsulta = $this->getManager("ManagerVideoConsulta")->insert($arr);


                    $create_session = $this->getManager("ManagerVideoConsultaSession")->iniciar_sesion_open_tok($videoconsulta);
                    if (!$create_session) {
                        $this->setMsg(["msg" => "Error. No se pudo procesar la video consulta.",
                            "result" => false
                        ]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                    }

                    if (!$videoconsulta || !$insert_mis_pacientes) {
                        $this->setMsg(["msg" => "Se produjo un error al cambiar el estado", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }

                    if ($turno["pago_stripe"] == "1") {
                        $process_cobro_stripe = true;
                    }
                }
            }
            //si se declina el turno se le devuelve la plata al paciente
            if ($request["estado"] == 3 || $request["estado"] == 2) {

                if ($this->is_turno_videoconsulta($id)) {


                    // FIX si se declina sin existir VC tenemos que devolver igual la plata al paciente


                    $devolucion = $this->getManager("ManagerMovimientoCuenta")->processDevolucionTurnoVideoConsulta($id);
                    if (!$devolucion) {
                        $this->setMsg(["msg" => "Se produjo un error al devolver el dinero del turno", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }

                    //eliminamos la videoconsulta correspeondiente
                    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                    $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $id);
                    if ($videoconsulta["idvideoconsulta"] != "") {
                        $borrarVC = $ManagerVideoConsulta->delete($videoconsulta["idvideoconsulta"]);
                        if (!$borrarVC) {
                            $this->setMsg(["msg" => "Se produjo un error al eliminar la videoconsulta", "result" => false]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                }
                //enviamos el mensaje al paciente;
                if ($request["mensaje"] != "") {
                    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                    $record_mensaje["cuerpo"] = $request["mensaje"];
                    $record_mensaje["paciente_idpaciente"] = $turno_prev["paciente_idpaciente"];
                    $mensaje_paciente = $ManagerNotificacion->createNotificacionMensajeMedicoPaciente($record_mensaje);
                    if (!$mensaje_paciente) {
                        $this->setMsg(["msg" => "Se produjo un error al cambiar el estado", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }
            }
            //actualizamos la notificacion con el nuevo estado del turno si el paciente envio una notificacion previa
            if ($request["alta_from_medico"] != 1) {
                $queryNotificacion = new AbstractSql();
                $queryNotificacion->setSelect("idnotificacion");
                $queryNotificacion->setFrom("notificacion");
                $queryNotificacion->setWhere("turno_idturno=$idturno");
                $queryNotificacion->addAnd("paciente_idpaciente_emisor=" . $turno_prev["paciente_idpaciente"]);

                $queryNotificacion->setOrderBy("fechaNotificacion DESC");

                $notificacion_reserva = $this->getList($queryNotificacion)[0];
                if ($notificacion_reserva["idnotificacion"] != "") {
                    $upd_notificacion_reserva = $this->getManager("ManagerNotificacion")->update(["estado_turno" => $request["estado"]], $notificacion_reserva["idnotificacion"]);
                    if (!$upd_notificacion_reserva) {
                        $this->setMsg(["result" => false, "msg" => "Error. No se ha podido reprogramar el turno seleccionado"]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }
            }


            //Enviamos la notificacion al paciente
            $request["idturno"] = $idturno;
            if ($request["alta_from_medico"] != 1) {
                $this->sendTurnoPacienteSMS($request);
                $this->sendTurnoPacienteEmail($request);
            }
            //realizamos el cobro en stripe -
            //cobrar al turnos videoconsulta
            if ($process_cobro_stripe) {
                $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                $confirmar_cobro = $ManagerCustomerStripe->confirmar_cobro_consulta($idturno, "turno");
                if (!$confirmar_cobro) {
                    $this->setMsg($ManagerCustomerStripe->getMsg());
                    $this->db->FailTrans();
                    return false;
                }
            }

            $this->setMsg(["result" => true, "msg" => "El turno ha sido actualizado"]);

            $this->db->CompleteTrans();
            //notificamos el evento al socket
            $client = new XSocketClient();
            $client->emit('cambio_estado_turno_php', $turno);

            return $id;
        } else {

            $this->setMsg(["result" => false, "msg" => "Se produjo un error al cambiar el estado"]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /**
     * Metodo que reserva un turno desde el medico a partir de un paciente seleccionado
     * 
     * @param type $request
     */
    public function reservar_turno_medico($request) {

        if (isset($request["paciente_idpaciente"]) && $request["paciente_idpaciente"] != "") {
            $request["idpaciente"] = $request["paciente_idpaciente"];
        }

        if (isset($request["idpaciente"]) && $request["idpaciente"] != "") {
            $request["paciente_idpaciente"] = $request["idpaciente"];
        }

        $turno = $this->get($request["idturno"]);

        $this->db->StartTrans();
        //verificamos si el turno aun se encuentra disponible
        if ($turno["estado"] != 0 || $turno["paciente_idpaciente"] != "") {
            $this->setMsg(["msg" => "El turno ya no se encuentra disponible", "result" => false]);
            return false;
        }
        $ManagerPaciente = $this->getManager("ManagerPaciente");


        $paciente = $ManagerPaciente->get($request["idpaciente"]);

        if (!$paciente) {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el paciente seleccionado", "result" => false]);
            return false;
        }

        $paciente["email"] = $ManagerPaciente->getPacienteEmail($request["idpaciente"]);

        if ($request["idmotivoVisita"] == "") {
            $this->setMsg(["msg" => "Error. Seleccione el motivo de la consulta", "result" => false]);
            return false;
        }

        //creamos el pago

        $is_turno_videoconsulta = $this->is_turno_videoconsulta($request["idturno"]);


        if ($is_turno_videoconsulta) {
            $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
            $request["monto"] = 0;
            $insert_cuenta = $ManagerMovimientoCuenta->processMovimientoTurnoVideoConsulta($request);

            if (!$insert_cuenta) {
                $this->setMsg($ManagerMovimientoCuenta->getMsg());
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $record["motivoVideoConsulta_idmotivoVideoConsulta"] = $request["idmotivoVisita"];
        } else {
            $record["motivovisita_idmotivoVisita"] = $request["idmotivoVisita"];
        }


        $record["estado"] = 1;
        $record["paciente_idpaciente"] = $request["idpaciente"];


        $record["alta_from_medico"] = $request["alta_from_medico"];
        $record["comentario"] = $request["mensaje"];


        $rdo = $this->updateFromFrontendTurno($record, $request["idturno"]);

        //si es una videoconsulta de prestado, seteamos el precio del prestador
        if ($is_turno_videoconsulta && CONTROLLER == "xadmin") {


            $request["prestador_idprestador"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['user']['prestador_idprestador'];
            $prestador = $this->getManager("ManagerPrestador")->get($request["prestador_idprestador"]);
            if ($prestador["valorVideoConsultaTurno"] == "" && $prestador["descuento"] == "") {

                $this->setMsg(["result" => false, "msg" => "Error. No tiene configurado el valor de la videoconsulta con turno"]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
            $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $request["idturno"]);

            //seteamos el precio que se cobra la VC
            //si el prestador ofrece un descuento, calculamos la tarifa sobre lo que cobra el medico y hacemos el descuento
            if ($prestador["descuento"] != "") {
                $preferencia_medico = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($videoconsulta["medico_idmedico"]);
                if ($preferencia_medico["valorPinesVideoConsultaTurno"] == "") {

                    $this->setMsg(["result" => false, "msg" => "Error. El profesional no tiene configurado el valor de la videoconsulta con turno para aplicar descuento"]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
                $precio_tarifa_prestador = $preferencia_medico["valorPinesVideoConsultaTurno"] - ($preferencia_medico["valorPinesVideoConsultaTurno"] * (int) $prestador["descuento"] / 100);
            } else {
                $precio_tarifa_prestador = $prestador["valorVideoConsultaTurno"];
            }
            $upd_videoconsulta = $ManagerVideoConsulta->basic_update(["from_prestador" => 1, "precio_tarifa_prestador" => $precio_tarifa_prestador, "prestador_idprestador" => $request["prestador_idprestador"], "comision_prestador" => 0], $videoconsulta["idvideoconsulta"]);
            if (!$upd_videoconsulta) {
                $this->setMsg(["msg" => "Ha ocurrido un error al setear el valor de la videoconsulta", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        if ($rdo) {
            $this->db->CompleteTrans();
            $this->setMsg(["msg" => "El turno ha sido reservado con éxito", "email" => $paciente["email"], "numeroCelular" => $paciente["numeroCelular"], "result" => true]);

            if ($is_turno_videoconsulta && CONTROLLER == "xadmin") {
                $client = new XSocketClient();
                //notify
                $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                $notify["text"] = "Nouvelle demande en Visio";
                $notify["medico_idmedico"] = $turno["medico_idmedico"];
                $notify["style"] = "video-consulta";
                $client->emit('notify_php', $notify);
                //evento de cambio de estado

                $client->emit('cambio_estado_videoconsulta_php', $videoconsulta);


                // LOG
                if (CONTROLLER != "xadmin") {

                    if ($is_turno_videoconsulta) {
                        // <-- LOG
                        $log["data"] = "Confirm medical appointment and send email confirmation - reason for consulting, patient name, date, time appointment";
                        $log["page"] = "Agenda";
                        $log["action"] = "val"; //"val" "vis" "del"
                        $log["purpose"] = "Add medical appointment with selected patient - Video consultation appointment";

                        $ManagerLog = $this->getManager("ManagerLog");
                        $ManagerLog->track($log);
                        // 
                    } else {
                        // <-- LOG
                        $log["data"] = "Confirm medical appointment and send email confirmation - reason for consulting, patient name, date, time appointment";
                        $log["page"] = "Agenda";
                        $log["action"] = "val"; //"val" "vis" "del"
                        $log["purpose"] = "Add medical appointment with selected patient - physical consultation appointment";

                        $ManagerLog = $this->getManager("ManagerLog");
                        $ManagerLog->track($log);
                        // 
                    }
                }
            }


            return true;
        } else {
            $this->setMsg(["msg" => "Ha ocurrido un error al interntar reservar el turno", "result" => false]);
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        }
    }

    /*     * Metodo que realiza la creacion de un paciente, y su miembro del grupo familiar en caso de ingresar un menor de edad, para
     * la reserva de un turno medico por parte del medico para un paciente no existente
     * 
     * @param type $request
     */

    public function paciente_nuevo_reservar_turno($request) {

        $alta_from_medico = 1;
        $request["numeroCelular"] = str_replace(" ", "", $request["numeroCelular"]);
        $request["numeroCelular"] = str_replace("-", "", $request["numeroCelular"]);
        //verificamos que venga un turno seleccionado
        if ($request["idturno"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo recuperar el turno seleccionado", "result" => false]);

            return false;
        }

        //verificamos los campos obligatgorios del formularios
        $campos_requerido = ["nombre", "apellido", "email"];
        foreach ($campos_requerido as $fiel) {
            if ($request[$fiel] == "") {
                $this->setMsg(["msg" => "Error. Verfique los campos obligatorios", "result" => false]);

                return false;
            }
        }
        //verificamos la edad del paciente  a crear
        $fecha_nac_sql = $this->sqlDate($request["fechaNacimiento"]);
        $calendar = new Calendar();
        $edad = $calendar->calculaEdad($fecha_nac_sql);
        if ($edad < 18) {
            //Vamos a permitir solo dar de alta pacientes mayores de edad
            $this->setMsg(["msg" => "Para crear una cuenta en DoctorPlus el paciente titular debe ser mayor de edad.", "result" => false]);
            return false;
        }

        //creamos el paciente titular mayor de edad
        $this->db->StartTrans();


        //generamos una password aleatoria
        $randomPass = $this->getManager("ManagerUsuarioWeb")->getRandomEasyPass(8);

        $randomPass_secure = sha1($randomPass);
        $randomPass_secure = base64_encode($randomPass_secure);
        $request["password"] = $randomPass_secure;

        $ManagerPaciente = $this->getManager("ManagerPaciente");

        $request["registrado"] = 1;
        $rdo_insert = $ManagerPaciente->registracion_paciente($request, $alta_from_medico);

        //verificamos si se pudo crear el paciente
        if (!$rdo_insert) {
            //Ocurrio un error, fallamos la transaccion

            $this->setMsg($ManagerPaciente->getMsg());
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            return false;
        } else {

            $idpaciente = $ManagerPaciente->getMsg()["idpaciente"];
            $request["alta_from_medico"] = 1;
            $request["idpaciente"] = $idpaciente;
            //si se creo el paciente, procedemos a crear el turno a ese paciente
            $rdo_turno = $this->reservar_turno_medico($request);

            if (!$rdo_turno) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                //el mensaje ya lo setea la creacion del turno
                return $rdo_turno;
            } else {
                $request["password"] = $randomPass;
                $rdo_email = $this->getManager("ManagerTurno")->sendEmailPacienteNuevoReservarTurno($request);
                $rdo_sms = $this->getManager("ManagerTurno")->sendSMSPacienteNuevoReservarTurno($request);

                if ($rdo_email) {
                    $this->setMsg(["msg" => "El paciente ha sido dado de alta con el turno reservado exitosamente", "email" => $request["email"], "numeroCelular" => $request["numeroCelular"], "result" => true]);
                    $this->db->CompleteTrans();
                    return true;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Ha ocurrido un error al interntar reservar el turno.", "result" => false]);
                    return false;
                }
            }
        }
    }

    /**
     * Método para la generación del cron.do
     * Distinto al otro "generate_cron", mando las configuraciones de agenda, Ya que el método "generateTurnosMedico"
     * está ocmprobado que anda
     * @return boolean
     */
    public function generateTurnosConfiguracion() {
        $ManagerMedicos = $this->getManager("ManagerMedico");
        //Obtengo todos los médicos activos

        $list_medicos = $ManagerMedicos->getListAllMedicosCron();

        if ($list_medicos && count($list_medicos) > 0) {
            $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");

            //Por cada médico obtengo su configuración de agenta y creo su turno
            foreach ($list_medicos as $key => $medico) {
                $listado_configuracion_agenda = $ManagerConfiguracionAgenda->getListAllConfiguracionAgenda($medico["idmedico"]);

                if ($listado_configuracion_agenda && count($listado_configuracion_agenda) > 0) {
                    foreach ($listado_configuracion_agenda as $key => $cf) {
                        $rdo = $this->generateTurnosMedico($cf, $medico["idmedico"], true);
                        if (!$rdo) {
                            return false;
                        }
                    }
                }
            }
        } else {
            return false;
        }
    }

    /**
     * Mpetod que genera los turnos del médico para ese mes  siempre y cuando 
     * @param type $configuracion_agenda
     * @return boolean
     */
    public function generateTurnosMedico($configuracion_agenda, $idmedico = null, $cron = false) {

        //Obtengo la fecha actual... Genero para todo el mes..
        $fecha = $this->sqlDate(date("d/m/Y"), '-', true);

        if ($cron == true) {
            //Si se generan turnos desde el Cron, se debe hacer 2 meses dsp´s 
            list($fecha_anio, $fecha_mes, $fecha_dia) = preg_split("[-]", $fecha);
            $fecha = date('Y-m-d', strtotime('+2 month', mktime(0, 0, 0, $fecha_mes, 1, $fecha_anio)));

            $cantidad_semanas_generar = 4;
        } else {
            $cantidad_semanas_generar = 8;
        }

        list($fecha_anio, $fecha_mes, $fecha_dia) = preg_split("[-]", $fecha);


        // Obtenemos el día de la semana de la fecha dada 
        $dia = date("w", mktime(0, 0, 0, $fecha_mes, $fecha_dia, $fecha_anio));

        //Si NO proviene del cron: Generación de la agenda a dos meses
        //Si viene del cron tengo que generar los horarios de dos meses dsp´s del actual
        $mes_limite = ($cron) ? $fecha_mes : $fecha_mes + 1;


        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }

        $ManagerCampaniasCronMedico = $this->getManager("ManagerCampaniasCronMedico");

        //Generación de la agenda a 8 semanas adelante
        for ($semana = 0; $semana <= $cantidad_semanas_generar; $semana++) {

            $inicio_semana = ($fecha_dia + $semana * 7) - $dia;
            $fecha_insert = date('Y-m-d', mktime(0, 0, 0, $fecha_mes, $inicio_semana, $fecha_anio));

            $horario_desde = "";
            do {
                if ($horario_desde == "") {
                    //Si es la primer iteración va la configuración desde de la configuración de la agenda
                    $horario_desde = $configuracion_agenda["desde"];
                } else {
                    $horario_desde = $horario_hasta;
                }

                //Duración de turnos los saco de la configuración de agenda
                $duracion_turno = (int) $configuracion_agenda["duracionTurnos"];

                $horario_hasta = $this->getRangoHorario($horario_desde, $duracion_turno);



                $dia_iddia = $configuracion_agenda["dia_iddia"];

                //Recorro todos los días de la semana -> No llego hasta el domingo
                //Creacion de la fecha que va a ser el turno
                list($fecha_anio_insert, $fecha_mes_insert, $fecha_dia_insert) = preg_split("[-]", $fecha_insert);

                $fecha_turno = date('Y-m-d', mktime(0, 0, 0, $fecha_mes_insert, ((int) $fecha_dia_insert + (int) $dia_iddia), $fecha_anio_insert));
                list($fta, $ftm, $ftd) = preg_split("[-]", $fecha_turno);


                if ($ftm <= $mes_limite && ($inicio_semana + $dia) >= $fecha_dia) {



                    //Si no hay ningún turno en ese rango de horario que lo inserte
                    //fix para segurarme que no inserto turnos los dias domingo
                    if (getNumeroDiaSemana($ftd, $ftm, $fta) != 6) {
                        $insert_turno = $this->insert(array(
                            "medico_idmedico" => $idmedico,
                            "estado" => 0,
                            "consultorio_idconsultorio" => $configuracion_agenda["consultorio_idconsultorio"],
                            "servicio_medico_idservicio_medico" => $configuracion_agenda["servicio_medico_idservicio_medico"],
                            "horarioInicio" => $horario_desde,
                            "horarioFin" => $horario_hasta,
                            "fecha" => $fecha_turno,
                            "configuracion_agenda_idconfiguracion_agenda" => $configuracion_agenda["idconfiguracionAgenda"]
                        ));

                        if (!$insert_turno) {
                            $this->setMsg(["msg" => "Error. No se pudo insertar el turno", "result" => true]);
                            return false;
                        }
                    }
                }
            } while ($horario_hasta != $configuracion_agenda["hasta"]);
        }

        $ManagerCampaniasCronMedico->insert([
            "medico_idmedico" => $idmedico,
            "fechaGeneracionAgenda" => date("Y-m-d")
        ]);
        return true;
    }

    /**
     * Método que retorna el listado de los turnos en los cuales los horarios de inicio y fin estén dentro de los rangos
     * Utilizado para saber si hay turnos donde se solapen los turnos
     * 
     * @param type $horarioInicio
     * @param type $horarioFin
     * @param type $fecha
     * @return boolean
     */
    private function is_exist_turno($horarioInicio, $horarioFin, $fecha, $idmedico = null) {

        if (is_null($idmedico)) {
            $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        }

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("fecha = '$fecha'
                AND (horarioInicio BETWEEN '$horarioInicio' AND '$horarioFin' OR horarioFin BETWEEN '$horarioInicio' AND '$horarioFin')
                AND (horarioFin <> '$horarioInicio')
               
                    ");

        $query->addAnd("estado <> 2");
        $query->addAnd("anulado=0");

        $query->addAnd("medico_idmedico = $idmedico");

        return $this->getList($query);
    }

    /*     * -Metodo que libera los turnos que han sido reservado por el paciente y han pasado 10 minutos sin confirmarse
     * 
     */

    public function cronActualizarEstadoTurnosReservados() {
        $this->db->Execute("update $this->table set estado=0,fechaReservaTurno=NULL,paciente_idpaciente=NULL, motivovisita_idmotivoVisita=NULL,"
                . " motivoVideoConsulta_idmotivoVideoConsulta=NULL, visitaPrevia=NULL, particular=NULL,obraSocial_idobraSocial=NULL,planObraSocial_idplanObraSocial=NULL"
                . " where estado=4 and DATE_ADD(fechaReservaTurno,INTERVAL 10 MINUTE) < SYSDATE()");
        $this->cronActualizarEstadoTurnosVencidos();


        //anulamos los turnos de VC pendientes que no fueron respondidos
        $this->getManager("ManagerVideoConsulta")->actualizarVencimientoTurnosVCPendientes();
    }

    /*     * -Metodo que libera los turnos que han sido vencidos por no confirmase por el medico 
     * 
     */

    public function cronActualizarEstadoTurnosVencidos() {

        $query = new AbstractSql();
        $query->setSelect("t.idturno");

        $query->setFrom("$this->table t");
        $query->setWhere("estado=0 AND paciente_idpaciente is not null and CONCAT(t.fecha,' ',t.horarioInicio) < SYSDATE() ");


        $listado = $this->getList($query);

        foreach ($listado as $turno) {
            $this->cancelarTurnoFromMedico($turno);
        }
    }

    /** Metodo del cron que se ejecuta atuomaticamente y envia un sms y mail al paciente recordando la fecha del turno que tiene
     * 24hs antes y 2hs antes del incio del turno
     * 
     */
    public function cronSendRecordatorioTurnoPaciente() {

        //Envio de recordatorio de los turnos 24hs antes de la fecha de inicio

        $fecha_hoy = date("Y-m-d");
        $hora_actual = date("H:i:s");
        $query1 = new AbstractSql();
        $query1->setSelect("t.*, 
                                CONCAT(tp.titulo_profesional,' ',uw.nombre,' ',uw.apellido ) as medico,
                                uw.sexo as sexo_medico,
                                uwp.nombre as nombre_paciente, 
                                uwp.apellido as apellido_paciente, 
                                uwp.email,
                                p.numeroCelular,
                                p.celularValido
                            ");

        $query1->setFrom("
               $this->table t
                   INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente)
                   INNER JOIN usuarioweb uwp ON (p.usuarioweb_idusuarioweb = uwp.idusuarioweb)
                   INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                   INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                   INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
            ");
        $query1->setWhere("t.estado=1");
        $query1->addAnd("t.isEnvioRecordatorio = 0");

        $query1->addAnd("DATE_ADD('$fecha_hoy',INTERVAL 1 DAY) = t.fecha");
        $query1->addAnd("t.horarioInicio <= '$hora_actual'");

        $listado = $this->getList($query1);

        foreach ($listado as $turno) {
            $result_envio_mail = $this->sendRecordatorioTurnoPacienteEmail($turno);
            $result_envio_sms = $this->sendRecordatorioTurnoPacienteSMS($turno);
            //Tengo que actualizar el registro de la base de datos para marcar que ya se enviaron los recordatorios
            if ($result_envio_mail || $result_envio_sms) {
                $rdo = parent::update(array("isEnvioRecordatorio" => 1), $turno[$this->id]);
            }
        }
        //Envio de recordatorio de los turnos 2hs antes de la fecha de inicio
        $query2 = new AbstractSql();
        $query2->setSelect("t.*, 
                                CONCAT(tp.titulo_profesional,' ',uw.nombre,' ',uw.apellido ) as medico,
                                uw.sexo as sexo_medico,
                                uwp.nombre as nombre_paciente, 
                                uwp.apellido as apellido_paciente, 
                                uwp.email,
                                p.numeroCelular,
                                p.celularValido
                            ");

        $query2->setFrom("
               $this->table t
                   INNER JOIN paciente p ON (t.paciente_idpaciente = p.idpaciente)
                   INNER JOIN usuarioweb uwp ON (p.usuarioweb_idusuarioweb = uwp.idusuarioweb)
                   INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                   INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                   INNER JOIN titulo_profesional tp ON (m.titulo_profesional_idtitulo_profesional=tp.idtitulo_profesional)
            ");

        $query2->setWhere("t.estado=1");
        $query2->addAnd("t.isEnvioRecordatorio = 0 || t.isEnvioRecordatorio = 1");
        $query2->addAnd("'$fecha_hoy' = t.fecha");
        $query2->addAnd("t.horarioInicio <= ADDTIME('$hora_actual','2:00:00') ");

        $listado2 = $this->getList($query2);

        foreach ($listado2 as $turno) {
            $result_envio_mail = $this->sendRecordatorioTurnoPacienteEmail($turno);
            $result_envio_sms = $this->sendRecordatorioTurnoPacienteSMS($turno);
            //Tengo que actualizar el registro de la base de datos para marcar que ya se enviaron los recordatorios
            if ($result_envio_mail || $result_envio_sms) {
                $rdo = parent::update(array("isEnvioRecordatorio" => 2), $turno[$this->id]);
            }
        }
    }

    /**
     * Método utilizado para enviar un evento en caso de que el paciente tenga configurado para recibir las notificaciones vía SMS
     * @param type request
     * @return boolean
     */
    public function sendTurnoPacienteSMS($request) {

        $turno = $this->get($request["idturno"]);


        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"]);
        $fecha = fechaToStringSMS($turno["fecha"] . " " . $turno["horarioInicio"], 1);


        //Se le debe avisar al paciente mediante algún tipo de notificación
        switch ((int) $request["estado"]) {
            case 0:
                //Pendiente
                $cuerpo = "Le rendez-vous du jour {$fecha} avec {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} est EN ATTENTE. " . URL_ROOT;
                break;
            case 1:
                //Confirmado
                $cuerpo = "Le rendez-vous du jour {$fecha} avec {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} est CONFIRMÉ. " . URL_ROOT;
                if ($this->is_turno_videoconsulta($turno["idturno"])) {
                    $cuerpo .= " Démarrer le test d'utilisation: " . URL_ROOT . "patient/checkrtc.html";
                }
                break;
            case 2:
                //Cancelado
                $cuerpo = "Le rendez-vous du jour {$fecha} avec {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} est ANNULÉ. " . URL_ROOT;
                break;
            case 3:
                //Declinado
                $cuerpo = "Le rendez-vous du jour {$fecha} avec {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} est DÉCLINÉ. " . URL_ROOT;
                break;
            case 5:
                //Declinado
                $sexo = ucfirst($sexo);
                $cuerpo = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} l'a marqué comme Patient absent le rendez-vous du jour {$fecha}";
                break;
            default:
                $cuerpo = "";
                break;
        }
        if ($paciente["numeroCelular"] != "" && $paciente["celularValido"] == 1) {

            /**
             * Inserción del SMS en la lista de envio
             */
            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'P',
                "paciente_idpaciente" => $turno["paciente_idpaciente"],
                "medico_idmedico" => $turno["medico_idmedico"],
                "contexto" => "Cambio Estado Turno",
                "texto" => $cuerpo,
                "numero_cel" => $paciente["numeroCelular"]
            ]);


            if ($sms) {
                $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
                return true;
            } else {
                $this->setMsg($ManagerLogSMS->getMsg());

                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * Metodo que envia un email al paciente cuando el medico cambia el estado de un turno solicitado
     * 
     * @param type $request
     * @return boolean
     */
    public function sendTurnoPacienteEmail($request) {
        $turno = $this->get($request["idturno"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        $paciente_turno["email"] = $ManagerPaciente->getPacienteEmail($turno["paciente_idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }


        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);


        switch ((int) $request["estado"]) {
            case 0:
                //Pendiente
                $turno_estado = "En attente";
                break;
            case 1:
                //Confirmado
                $turno_estado = "Confirmé";
                break;
            case 2:
                //Cancelado
                $turno_estado = "Annulé";
                break;
            case 3:
                //Declinado
                $turno_estado = "Décliné";
                break;
            case 5:
                //Declinado
                $turno_estado = "Patient absent";
                break;
            default:
                $cuerpo = "";
                break;
        }
        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare:  Rendez-vous Nº {$turno["idturno"]} {$turno_estado}");
        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $turno_videoconsulta = 1;
            $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($turno["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];
        } else {
            $motivo = $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"])["motivoVisita"];
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $smarty = SmartySingleton::getInstance();

        //
        $smarty->assign("turno_estado", $turno_estado);
        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("paciente_turno", $paciente_turno);
        $smarty->assign("paciente_titular", $paciente_titular);

        $smarty->assign("turno", $turno);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $motivo);
        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);
        $smarty->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $mEmail->setBody($smarty->Fetch("email/notificacion_cambio_estado_turno.tpl"));

        if ($paciente_titular["email"] != "") {
            $mEmail->addTo($paciente_titular["email"]);
            //header a todos los comentarios!

            return $mEmail->send();
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Metodo que envia un email al medico cuando el paciente cancela un turno solicitado
     * 
     * @param type $request
     * @return boolean
     */
    public function sendCancelacionTurnoPacienteEmail($request) {

        $turno = $this->get($request["idturno"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($request["idpaciente"]);
        $paciente_turno["email"] = $ManagerPaciente->getPacienteEmail($request["idpaciente"]);
        $paciente_turno["imagen"] = $ManagerPaciente->getImagenPaciente($request["idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);


        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $mEmail->setSubject("WorknCare |  Rendez-vous de Vidéo Consultation Nº {$request["idturno"]} est annulée");
            $turno_videoconsulta = 1;
        } else {
            $mEmail->setSubject("WorknCare |  Rendez-vous au cabinet Nº {$request["idturno"]} est annulée");
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("paciente_turno", $paciente_turno);
        $smarty->assign("paciente_titular", $paciente_titular);

        $smarty->assign("turno", $turno);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $request["mensaje_cancelacion_turno"]);
        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);
        $smarty->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $mEmail->setBody($smarty->Fetch("email/notificacion_cancelacion_turno_paciente.tpl"));

        if ($medico["email"] != "") {
            $mEmail->addTo($medico["email"]);
            //header a todos los comentarios!

            return $mEmail->send();
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Metodo que envia un email al medico cuando el paciente reprograma un turno solicitado
     * 
     * @param type $request
     * @return boolean
     */
    public function sendReprogramacionTurnoPacienteEmail($request) {

        $turno = $this->get($request["idturno"]);
        $turno_nuevo = $this->get($request["idturno_reprogramar"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($request["idpaciente"]);
        $paciente_turno["email"] = $ManagerPaciente->getPacienteEmail($request["idpaciente"]);
        $paciente_turno["imagen"] = $ManagerPaciente->getImagenPaciente($request["idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);
        $fecha_turno_nuevo = fechaToString($turno_nuevo["fecha"] . " " . $turno_nuevo["horarioInicio"], 1);

        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $mEmail->setSubject("WorknCare |  Rendez-vous de Vidéo Consultation Nº {$request["idturno"]} reporté");
            $turno_videoconsulta = 1;
        } else {
            $mEmail->setSubject("WorknCare |  Rendez-vous au cabinet Nº {$request["idturno"]} reporté");
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("fecha_turno_nuevo", $fecha_turno_nuevo);
        $smarty->assign("paciente_turno", $paciente_turno);
        $smarty->assign("paciente_titular", $paciente_titular);

        $smarty->assign("turno", $turno);
        $smarty->assign("turno_nuevo", $turno_nuevo);
        $smarty->assign("medico", $medico);

        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);
        $smarty->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $mEmail->setBody($smarty->Fetch("email/notificacion_reprogramacion_turno_paciente.tpl"));

        if ($medico["email"] != "") {
            $mEmail->addTo($medico["email"]);
            //header a todos los comentarios!

            return $mEmail->send();
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Metodo que envia un email al medico cuando el paciente solicita un turno
     * 
     * @param type $request
     * @return boolean
     */
    public function sendSolicitudTurnoEmail($request) {

        $turno = $this->get($request["idturno"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        $paciente_turno["email"] = $ManagerPaciente->getPacienteEmail($turno["paciente_idpaciente"]);
        $paciente_turno["imagen"] = $ManagerPaciente->getImagenPaciente($turno["paciente_idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }


        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);

        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");


        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $mEmail->setSubject("WorknCare: Nouvelle demande de Vidéo Consultation sur RDV Nº{$request["idturno"]}");
            $turno_videoconsulta = 1;
            $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($turno["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];
        } else {
            $mEmail->setSubject("WorknCare | Nouvelle demande de rendez-vous au cabinet Nº{$request["idturno"]}");
            $motivo = $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"])["motivoVisita"];
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $smarty = SmartySingleton::getInstance();


        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("paciente_turno", $paciente_turno);
        $smarty->assign("paciente_titular", $paciente_titular);

        $smarty->assign("turno", $turno);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $motivo);
        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);
        $smarty->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $mEmail->setBody($smarty->Fetch("email/notificacion_solicitud_turno.tpl"));

        if ($medico["email"] != "") {
            $mEmail->addTo($medico["email"]);
            //header a todos los comentarios!

            return $mEmail->send();
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Metodo que envia un email al paciente cuando el medico cambia el estado de un turno solicitado
     * 
     * @param type $request
     * @return boolean
     */
    public function sendEmailPacienteNuevoReservarTurno($request) {

        $turno = $this->get($request["idturno"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        $paciente_turno["email"] = $ManagerPaciente->getPacienteEmail($turno["paciente_idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }


        //obtenemos el medico del turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare: RDV Nº" . $turno["idturno"] . " Confirmé");
        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $turno_videoconsulta = 1;
            $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($turno["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];
        } else {
            $motivo = $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"])["motivoVisita"];
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $usuario = $this->getManager("ManagerUsuarioWeb")->get($paciente_titular["usuarioweb_idusuarioweb"]);

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("paciente_turno", $paciente_turno);
        $smarty->assign("paciente_titular", $paciente_titular);
        $smarty->assign("password", $request["password"]);
        $smarty->assign("turno", $turno);
        $smarty->assign("medico", $medico);
        $smarty->assign("motivo", $motivo);
        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);
        $smarty->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $smarty->assign("sistema", NOMBRE_SISTEMA);
        $smarty->assign("hash", $usuario["checkemail"]);



        $mEmail->setBody($smarty->Fetch("email/nuevo_paciente_reservar_turno.tpl"));

        if ($paciente_titular["email"] != "") {

            $mEmail->addTo($paciente_titular["email"]);

            //header a todos los comentarios!

            return $mEmail->send();
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    public function sendSMSPacienteNuevoReservarTurno($request) {

        $turno = $this->get($request["idturno"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente_turno = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        $paciente_turno["celular"] = $ManagerPaciente->getPacienteTelefono($turno["paciente_idpaciente"]);

        //verificamos si es paciente titular o miembro del grupo familiar
        $relaciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente_turno["idpaciente"]);
        if ($relaciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente_titular = $ManagerPaciente->get($relaciongrupo["pacienteTitular"]);
        } else {
            //el paciente del turno es el mismo paciente titular de la cuenta
            $paciente_titular = $paciente_turno;
        }


        //obtenemos el medico del turno
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], 1);
        $fecha = fechaToString($turno["fecha"] . " " . $turno["horarioInicio"], 1);



        $cuerpo = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} vous a envoyé une invitation pour rendez-vous le {$fecha}!"
                . " Les données d'enregistrement ont été envoyées à votre email."
                . " Se connecter à " . URL_ROOT;

        if ($request["numeroCelular"] != "") {
            /**
             * Inserción del SMS en la lista de envio
             */
            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'P',
                "paciente_idpaciente" => $turno["paciente_idpaciente"],
                "medico_idmedico" => $turno["medico_idmedico"],
                "contexto" => "Nuevo Turno",
                "texto" => $cuerpo,
                "numero_cel" => $request["numeroCelular"]
            ]);


            if ($sms) {
                $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
                return true;
            } else {
                $this->setMsg($ManagerLogSMS->getMsg());

                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Mpétodo utilizado para el envio de recordatorio por email de turnos de los pacientes que se encuentran en el sistema
     * @param type $turno
     * @return boolean
     */
    private function sendRecordatorioTurnoPacienteEmail($turno) {
        $fecha = fechaToStringSMS($turno["fecha"] . " " . $turno["horarioInicio"], 1);

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($turno["medico_idmedico"], true);

        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");
        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $mEmail->setSubject("WorknCare : Rappel de RDV en Visio");
            $turno_videoconsulta = 1;
            $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($turno["motivoVideoConsulta_idmotivoVideoConsulta"])["motivoVideoConsulta"];
        } else {
            $mEmail->setSubject("WorknCare | Rappel de rendez-vous");
            $motivo = $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"])["motivoVisita"];
        }

        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("medico", $medico);
        $smarty->assign("fecha_turno", $fecha);
        $smarty->assign("turno", $turno);
        $smarty->assign("motivo", $motivo);
        $smarty->assign("consultorio", $consultorio);
        $smarty->assign("turno_videoconsulta", $turno_videoconsulta);


        $mEmail->setBody($smarty->Fetch("email/recordatorio_turno_paciente.tpl"));


        $mEmail->addTo($turno["email"]);


        //header a todos los comentarios!
        if ($mEmail->send()) {

            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo enviar el mensaje"]);
            return false;
        }
    }

    /**
     * Mpétodo utilizado para el envio de recordatorio por sms de turnos de los pacientes que se encuentran en el sistema
     * @param type $turno
     * @return boolean
     */
    private function sendRecordatorioTurnoPacienteSMS($turno) {

        $fecha = fechaToStringSMS($turno["fecha"] . " " . $turno["horarioInicio"], 1);

        if ($turno["sexo_medico"] == "1") {
            $sexo = "el";
        } else {
            $sexo = "la";
        }
        if ($this->is_turno_videoconsulta($turno["idturno"])) {
            $cuerpo = "Rappel de rendez-vous en Visio avec {$turno["medico"]}: {$fecha}hs.";
            $cuerpo .= " Démarrer le test d'utilisation: " . URL_ROOT . "patient/checkrtc.html";
        } else {
            $cuerpo = "Rappel de rendez-vous avec {$turno["medico"]}:  {$fecha}hs";
        }


        if ($turno["numeroCelular"] != "" && $turno["celularValido"] == 1) {

            /**
             * Inserción del SMS en la lista de envio
             */
            $ManagerLogSMS = $this->getManager("ManagerLogSMS");
            $sms = $ManagerLogSMS->insert([
                "dirigido" => 'P',
                "paciente_idpaciente" => $turno["paciente_idpaciente"],
                "medico_idmedico" => $turno["medico_idmedico"],
                "contexto" => "Recordatorio Turno",
                "texto" => $cuerpo,
                "numero_cel" => $turno["numeroCelular"]
            ]);


            if ($sms) {
                $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
                return true;
            } else {
                $this->setMsg($ManagerLogSMS->getMsg());

                return false;
            }
        } else {
            return false;
        }
    }

    /*     * Metodo que retorna el estado true o false si el medico ha definida una configuracion para la agenda de turnos
     * 
     */

    public function isAgendaDefinida($idconsultorio) {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $rs = $this->db->getRow("select count(*) as qty from configuracionagenda where medico_idmedico=$idmedico and consultorio_idconsultorio=$idconsultorio");
        return $rs["qty"] > 0;
    }

    /*     * Metodo que retorna el listado de turnos en formato para slider de home Paciente
     * 
     * @param type $idpaciente
     */

    public function getListadoSiguientesTurnosHome($idpaciente) {
        $request["idpaciente"] = $idpaciente;
        $listado = $this->getListSiguientesTurnosPaciente($request)["rows"];
        $count = COUNT($listado);
        $result = [];
        $par = [];
        //recorremos el listado y lo agrupamos de a 2 notificaciones
        if ($listado) {
            for ($i = 1; $i <= $count; $i++) {

                $par[] = $listado[$i - 1];
                if ($i % 2 == 0) {
                    $result[] = $par;
                    $par = [];
                }
                //si es impar, el ultimo lo agregamos solo
                elseif ($i == $count) {
                    $result[] = $par;
                }
            }
        }
        return $result;
    }

    /*     * Metodo mediante el cual el medico vuelve a habilitar un turno declinado limpiando todos los campos
     * para que pueda ser solicitado por otro paciente
     * 
     * @param type $idturno
     * @return boolean
     */

    public function habilitarTurnoFromMedico($idturno) {
        $turno = parent::get($idturno);
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        if ($turno["medico_idmedico"] != $idmedico) {
            $this->setMsg(["msg" => "No se pudo recuperar el turno", "result" => false]);
            return false;
        }
        if ($turno["estado"] != 3) {
            $this->setMsg(["msg" => "El turno no se encuentra en estado Declinado", "result" => false]);
            return false;
        }
        //limpiamos todos los campos del turno para que este disponible
        $record["estado"] = 0;
        $record["paciente_idpaciente"] = "";
        $record["comentario"] = "";
        $record["asistenciaPaciente"] = "";
        $record["anulado"] = "";
        $record["isEnvioRecordatorio"] = 0;
        $record["fechaSolicitudTurno"] = "";
        $record["fechaReservaTurno"] = "";
        $record["fechaCambioEstado"] = "";
        $record["motivovisita_idmotivoVisita"] = "";
        $record["visitaPrevia"] = 0;
        $record["particular"] = 0;
        $record["planObraSocial_idplanObraSocial"] = "";
        $record["perfilSaludConsulta_idperfilSaludConsulta"] = "";
        $record["motivoVideoConsulta_idmotivoVideoConsulta"] = "";
        $rdo = $this->update($record, $idturno);
        if ($rdo) {
            $this->setMsg(["msg" => "El turno ha sido habilitado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo habilitar el turno", "result" => false]);
            return false;
        }
    }

    /**
     * Método utilizado para cancelar el turno y dsp´s enviar la notificacion al médico
     * @param type $request
     * @return boolean
     */
    public function cancelarTurnoFromPaciente($request) {

        $this->db->StartTrans();
        $idturno = (int) $request["id"];
        if ($request["mensaje_cancelacion_turno"] == "") {
            $this->setMsg(["msg" => "Indique el motivo por el que desea cancelar el turno", "result" => false]);
            return false;
        }

        if ($idturno > 0) {


            $turno = parent::get($idturno);

            if ($turno) {

                //si es turno de videoconsulta la elimino
                $turno_videoconsulta = 0;
                if ($this->is_turno_videoconsulta($idturno)) {
                    $turno_videoconsulta = 1;
                    $devolucion = $this->getManager("ManagerMovimientoCuenta")->processDevolucionTurnoVideoConsulta($idturno);
                    if (!$devolucion) {
                        $this->setMsg(["msg" => "Se produjo un error al devolver el dinero del turno", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }

                    //eliminamos la videoconsulta correspeondiente
                    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                    $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $idturno);
                    if ($videoconsulta["idvideoconsulta"] != "") {
                        $borrarVC = $ManagerVideoConsulta->delete($videoconsulta["idvideoconsulta"]);
                        if (!$borrarVC) {
                            $this->setMsg(["msg" => "Se produjo un error al eliminar la videoconsulta", "result" => false]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                }


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
                $record["idturno"] = $turno["idturno"];
                $record["mensaje_cancelacion_turno"] = $request["mensaje_cancelacion_turno"];
                $notificacion = $ManagerNotificacion->createNotificacionFromCancelacionTurnoPaciente($record);

                $update = parent::update($update_turno, $idturno);

                $record_mail["idturno"] = $turno["idturno"];
                $record_mail["mensaje_cancelacion_turno"] = $request["mensaje_cancelacion_turno"];
                $record_mail["idpaciente"] = $turno["paciente_idpaciente"];
                $this->sendCancelacionTurnoPacienteEmail($record_mail);

                if ($update && $notificacion) {
                    $this->setMsg(["result" => true, "msg" => "El turno fue cancelado con éxito."]);

                    //notificamos al medico

                    $client = new XSocketClient();
                    $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
                    $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Notification";
                    if ($turno_videoconsulta) {
                        $notify["text"] = "Rendez-vous de Vidéo Consultation annulée";
                    } else {
                        $notify["text"] = "Rendez-vous au cabinet annulée";
                    }

                    $notify["medico_idmedico"] = $turno["medico_idmedico"];
                    $notify["style"] = "notificacion";
                    $notify["type"] = "notificacion";
                    $client->emit('notify_php', $notify);

                    //notificamos el evento al paciente
                    $client->emit('cambio_estado_turno_php', $turno);

                    // <-- LOG
                    $log["data"] = "Reason for medical appointment, patient consulting, profesional name, specialty, date & time appointment, appointment number, optional comentary";
                    $log["page"] = "Home page (connected)";
                    $log["action"] = "val"; //"val" "vis" "del"
                    $log["purpose"] = " Cancel Booking Physical Consultation with connected Frequent Professional";

                    $ManagerLog = $this->getManager("ManagerLog");
                    $ManagerLog->track($log);
                    $this->db->CompleteTrans();

                    return true;
                }
            }
        }


        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
        return false;
    }

    /**
     * Método mediante el que un medico cancela un turno y queda disponible para otro paciente.
     * @param type $request
     * @return boolean
     */
    public function cancelarTurnoFromMedico($request) {

        $idturno = $request["idturno"];
        if ($idturno > 0) {

            $turno = parent::get($idturno);
            //verifico que el turno pertenezca al medico
            if (CONTROLLER == "medico") {
                $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
                $request["idmedico"] = $idmedico;
                if ($turno["medico_idmedico"] != $idmedico) {
                    $this->setMsg(["msg" => "Error. No se pudo recuperar el turno", "result" => false]);
                    return false;
                }
            }

            if ($turno) {
                $this->db->StartTrans();
                //Tengo que modificar el turno y dejarlo disponible para otro paciente 
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
                    "beneficia_reintegro" => "",
                    "grilla_idgrilla" => "",
                    "grilla_excepcion_idgrilla_excepcion" => "",
                    "stripe_payment_intent_id" => "",
                    "stripe_payment_method" => "",
                    "pago_stripe" => 0,
                    "idprograma_categoria" => ""
                );


                if ($this->is_turno_videoconsulta($idturno)) {

                    $devolucion = $this->getManager("ManagerMovimientoCuenta")->processDevolucionTurnoVideoConsulta($idturno);
                    if (!$devolucion) {
                        $this->setMsg(["msg" => "Se produjo un error al devolver el dinero del turno", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }


                    //eliminamos la videoconsulta correspeondiente
                    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                    $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $idturno);
                    if ($videoconsulta["idvideoconsulta"] != "") {
                        $borrarVC = $ManagerVideoConsulta->delete($videoconsulta["idvideoconsulta"]);
                        if (!$borrarVC) {
                            $this->setMsg(["msg" => "Se produjo un error al eliminar la videoconsulta", "result" => false]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                }
                //Cuando el médico cancela el turno, genero una notificación para el paciente
                $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                $notificacion = $ManagerNotificacion->createNotificacionFromCancelacionTurnoMedico($idturno);
                //Envío la notificacion al paciente de cancelación
                $record["idturno"] = $idturno;
                $record["estado"] = 2;

                $mail = $this->sendTurnoPacienteEmail($record);
                $this->sendTurnoPacienteSMS($record);

                //enviamos el mensaje al paciente;
                if ($request["mensaje"] != "") {
                    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                    $record_mensaje["cuerpo"] = $request["mensaje"];
                    $record_mensaje["paciente_idpaciente"] = $turno["paciente_idpaciente"];
                    $record_mensaje["idmedico"] = $turno["medico_idmedico"];
                    $mensaje_paciente = $ManagerNotificacion->createNotificacionMensajeMedicoPaciente($record_mensaje);
                    if (!$mensaje_paciente) {
                        $this->setMsg(["msg" => "Se produjo un error al cambiar el estado", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }



                $update = parent::update($update_turno, $idturno);


                if ($update && $notificacion && $mail) {
                    //notificamos el evento al socket
                    $client = new XSocketClient();
                    $client->emit('cambio_estado_turno_php', $turno);
                    $this->db->CompleteTrans();
                    $this->setMsg(["result" => true, "msg" => "El turno fue cancelado con éxito."]);
                    return true;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
                    return false;
                }
            }
        }


        $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
        return false;
    }

    /**
     * Método mediante el que un cron cancela un turno pendiente sin respuesta y queda disponible para otro paciente.
     * @param type $request
     * @return boolean
     */
    public function cancelarTurnoFromCron($request) {

        $idturno = $request["idturno"];
        if ($idturno > 0) {

            $turno = parent::get($idturno);

            if ($turno) {
                $this->db->StartTrans();
                //Tengo que modificar el turno y dejarlo disponible para otro paciente 
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
                    "beneficia_reintegro" => "",
                    "grilla_idgrilla" => "",
                    "grilla_excepcion_idgrilla_excepcion" => "",
                    "stripe_payment_intent_id" => "",
                    "stripe_payment_method" => "",
                    "pago_stripe" => 0,
                    "idprograma_categoria" => ""
                );


                if ($this->is_turno_videoconsulta($idturno)) {

                    $devolucion = $this->getManager("ManagerMovimientoCuenta")->processDevolucionTurnoVideoConsulta($idturno);
                    if (!$devolucion) {
                        $this->setMsg(["msg" => "Se produjo un error al devolver el dinero del turno", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }


                    //eliminamos la videoconsulta correspeondiente
                    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                    $videoconsulta = $ManagerVideoConsulta->getByField("turno_idturno", $idturno);
                    if ($videoconsulta["idvideoconsulta"] != "") {
                        $borrarVC = $ManagerVideoConsulta->delete($videoconsulta["idvideoconsulta"]);
                        if (!$borrarVC) {
                            $this->setMsg(["msg" => "Se produjo un error al eliminar la videoconsulta", "result" => false]);
                            $this->db->FailTrans();
                            $this->db->CompleteTrans();
                            return false;
                        }
                    }
                }
                //Cuando el médico cancela el turno, genero una notificación para el paciente
                $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                $notificacion = $ManagerNotificacion->createNotificacionFromCancelacionTurnoMedico($idturno);
                //Envío la notificacion al paciente de cancelación
                $record["idturno"] = $idturno;
                $record["estado"] = 2;

                $mail = $this->sendTurnoPacienteEmail($record);
                $this->sendTurnoPacienteSMS($record);

                //enviamos el mensaje al paciente;
                if ($request["mensaje"] != "") {
                    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                    $record_mensaje["cuerpo"] = $request["mensaje"];
                    $record_mensaje["paciente_idpaciente"] = $turno["paciente_idpaciente"];
                    $record_mensaje["idmedico"] = $turno["medico_idmedico"];
                    $mensaje_paciente = $ManagerNotificacion->createNotificacionMensajeMedicoPaciente($record_mensaje);
                    if (!$mensaje_paciente) {
                        $this->setMsg(["msg" => "Se produjo un error al cambiar el estado", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                }



                if ($notificacion && $mail) {
                    $update = parent::update($update_turno, $idturno);
                    if (!$update) {
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
                    }
                    //notificamos el evento al socket
                    $client = new XSocketClient();
                    $client->emit('cambio_estado_turno_php', $turno);
                    $this->db->CompleteTrans();
                    $this->setMsg(["result" => true, "msg" => "El turno fue cancelado con éxito."]);
                    return true;
                } else {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
                    return false;
                }
            }
        }


        $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
        return false;
    }

    /**
     * Método que cancela la creación del turno.
     * @param type $request
     * @return boolean
     */
    public function cancelarTurnoFromCreacion($request) {

        $idturno = (int) $request["id"];
        if ($idturno > 0) {

            $turno = parent::get($idturno);
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            if ($turno["paciente_idpaciente"] != $paciente["idpaciente"]) {
                $this->setMsg(["msg" => "Error. No se pudo recuperar el turno", "result" => false]);
                return false;
            }
            if ($turno) {

                //Tengo que modificar el turno y enviar una notificación al médico
                $update_turno = array(
                    "estado" => 0, //pendiente
                    "comentario" => "",
                    "asistenciaPaciente" => "",
                    "anulado" => "",
                    "isEnvioRecordatorio" => 0,
                    "paciente_idpaciente" => "",
                    "fechaSolicitudTurno" => "",
                    "fechaCambioEstado" => "",
                    "fechaReservaTurno" => "",
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

                $update = parent::update($update_turno, $idturno);
                if ($update) {
                    //Envío la notificacion al paciente de cancelación
                    $this->setMsg(["result" => true, "msg" => "El turno fue cancelado con éxito."]);
                    return true;
                }
            }
        }

        $this->setMsg(["msg" => "Error. No se pudo cancelar el turno", "result" => false]);
        return false;
    }

    /**
     *  Metodo que retorna si el turno corresponde a una videoconsulta, verificacion si el consultorio es virtual
     * @param type $idturno
     * @return boolean
     */
    public function is_turno_videoconsulta($idturno) {
        $turno = $this->get($idturno);
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        if ($consultorio["is_virtual"] == "1") {
            return true;
        } else {
            return false;
        }
    }

    /**
     *  Metodo que retorna un listado de turnos para un periodo de tiempo , su estado actual y paciente asignado
     *
     * @param type $idconsultorio consultorio de los turnos
     * @param type $fecha fecha inicio listado
     * @param int $tipo  1-hoy, 2-mes, 3-prox 7 dias, 4-prox 15 dias, 5-prox 30 dias
     * @return type List
     */
    public function getListadoTrunosAgendaMensual($idconsultorio, $fecha, $tipo) {


        $query = new AbstractSql();
        $query->setSelect("idturno,
                            estado,
                            CASE estado
                                WHEN 0 THEN
                                        'Disponible'
                                WHEN 1 THEN
                                        'Confirmado'
                                WHEN 2 THEN
                                        'Cancelado'
                                WHEN 3 THEN
                                        'Declinado'
                                WHEN 4 THEN
                                        'no confirmado por paciente'
                                WHEN 5 THEN 'Ausente'
                            END AS estado_turno,
                     fecha,
                     horarioInicio,
                     horarioFin,
                    CONCAT(v.apellido,' ',v.nombre) as paciente");
        $query->setFrom("turno t LEFT JOIN v_medicos_pacientes v on (t.paciente_idpaciente=v.id and v.tipousuario='paciente')");
        $query->setWhere("consultorio_idconsultorio = {$idconsultorio}");
        //filtramos las fechas
        switch ((int) $tipo) {
            case 1:
                //dia de hoy
                $query->addAnd("fecha='$fecha'");
                break;
            case 2:
                //este mes
                $mes = date("m");
                $query->addAnd(" fecha LIKE ('%-{$mes}-%')");
                break;
            case 3:
                //proximos 7 dias
                $fecha_fin = date('Y-m-d', strtotime('+7 day', strtotime($fecha)));
                $query->addAnd("fecha BETWEEN '$fecha' AND '$fecha_fin'");
                break;
            case 4:
                //proximos 15 dias
                $fecha_fin = date('Y-m-d', strtotime('+15 day', strtotime($fecha)));
                $query->addAnd("fecha BETWEEN '$fecha' AND '$fecha_fin'");
                break;
            case 5:
                //proximos 30 dias
                $fecha_fin = date('Y-m-d', strtotime('+30 day', strtotime($fecha)));
                $query->addAnd("fecha BETWEEN '$fecha' AND '$fecha_fin'");
                break;
            default:
                //este mes
                $mes = data("m");
                $query->addAnd(" fecha LIKE ('%-{$mes}-%')");
                break;
        }
        $query->setOrderBy("fecha");

        $rdo = $this->getList($query);

        return $rdo;
    }

    /** Generaion del la agenda de turnos del medico en Excel para sus consultorios
     * 
     * @param type $fecha fecha de inicio listado
     * @param type $tipo @param int $tipo  1-hoy, 2-mes, 3-prox 7 dias, 4-prox 15 dias, 5-prox 30 dias
     */
    public function ExportarAgendaXLS($fecha = null, $tipo = null) {
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel.php"));
        require_once(path_libs_php("PHPExcel/Classes/PHPExcel/IOFactory.php"));

        //si no se selecciona un mes obtenemos el actual
        //fecha actual por defecto
        if (is_null($fecha)) {
            $fecha = date("d/m/Y");
        }

        //tipo listado mensual por defecto
        if (is_null($tipo)) {
            $tipo = 2;
        }


        //fecha viene en formato MM/DD/YYYY
        list($dia, $mes, $anio) = preg_split("[/]", $fecha);
        $fecha_sql = "$anio-$mes-$dia";
        $nombre_mes = getNombreMes((int) $mes);

        //obtenemos los consulorios del medico
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $consultorios = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($idmedico);

        //Obtener Listado Según El Excel que se necesite obtener
        //template
        $inputFileName = path_root() . "xframework/app/medico/view/templates/excel/agenda_medico_template.xlsx";
        $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
        $objReader = PHPExcel_IOFactory::createReader($inputFileType);
        $objPHPExcel = $objReader->load($inputFileName);


        $i = 0;
        //iteramos sobre los turnos de cada consultorio
        foreach ($consultorios as $consultorio) {
            $objPHPExcel->setActiveSheetIndex($i);
            $active_sheet = $objPHPExcel->getActiveSheet();



            $agenda = $this->getListadoTrunosAgendaMensual($consultorio["idconsultorio"], $fecha_sql, $tipo);

            $r_init = $r_start = 10;
            $params_xls = array(
                "r_start" => $r_start,
                "active_sheet" => $active_sheet
            );

            $pendientes = 0;
            $disponibles = 0;
            $confirmados = 0;
            $declinados = 0;
            $ausentes = 0;
            //Escribir Agenda turnos
            foreach ($agenda as $turno) {


                $active_sheet->setCellValue("A$r_start", fechaToString($turno["fecha"]));
                $active_sheet->setCellValue("B$r_start", substr($turno["horarioInicio"], 0, 5));
                $active_sheet->setCellValue("C$r_start", substr($turno["horarioFin"], 0, 5));
                $active_sheet->setCellValue("D$r_start", $turno["estado_turno"]);
                $active_sheet->setCellValue("E$r_start", $turno["paciente"]);

                $r_start++;
                $params_xls["r_start"] = $r_start;

                //contador de estados
                switch ((int) $turno["estado"]) {
                    case 0:
                        if ($turno["paciente"] != "") {
                            $pendientes++;
                        } else {
                            $disponibles++;
                        }
                        break;
                    case 1:
                        $confirmados++;
                        break;
                    case 3:
                        $declinados++;
                        break;
                    case 5:
                        $ausentes++;
                        break;
                }
            }

            //establecemos el titulo y nombre del archivo segun el tipo de agenda
            switch ((int) $tipo) {
                case 1:
                    //dia de hoy
                    $titulo = fechaToString($fecha_sql);
                    break;
                case 2:
                    //este mes
                    $titulo = $nombre_mes . " " . $anio;
                    break;
                case 3:
                    //proximos 7 dias
                    $fecha_fin = date('Y-m-d', strtotime('+7 day', strtotime($fecha_sql)));
                    $titulo = fechaToString($fecha_sql) . " - " . fechaToString($fecha_fin);
                    break;
                case 4:
                    //proximos 15 dias
                    $fecha_fin = date('Y-m-d', strtotime('+15 day', strtotime($fecha_sql)));
                    $titulo = fechaToString($fecha_sql) . " - " . fechaToString($fecha_fin);
                    break;
                case 5:
                    //proximos 30 dias
                    $fecha_fin = date('Y-m-d', strtotime('+30 day', strtotime($fecha_sql)));
                    $titulo = fechaToString($fecha_sql) . " - " . fechaToString($fecha_fin);
                    break;
                default:
                    //este mes
                    //este mes
                    $titulo = $nombre_mes;
                    break;
            }
            //Escribir Cabecera
            $active_sheet->setCellValue("A3", "Agenda $titulo");
            $cellStyle = $active_sheet->getStyle('A3');
            $fontStyle = $cellStyle->getFont();
            $fontStyle->setSize(14);
            $fontStyle->setBold(true);
            $active_sheet->mergeCells('A3:E3');
            $active_sheet->getStyle('A3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);


            unset($agenda["cantidades"]);


            $active_sheet->setCellValue("B5", "Confirmé: " . $confirmados);
            $active_sheet->setCellValue("B6", "Disponible: " . $disponibles);
            $active_sheet->setCellValue("B7", "Absent: " . $ausentes);
            $active_sheet->setCellValue("D5", "En attente: " . $pendientes);
            $active_sheet->setCellValue("D6", "Refusé: " . $declinados);

            $active_sheet->setTitle($consultorio["nombreConsultorio"]);

            $i++;
        }
        //configuracion de hoja

        $active_sheet->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_PORTRAIT);
        $active_sheet->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
        $active_sheet->getPageSetup()->setFitToPage(true);
        $active_sheet->getPageSetup()->setFitToWidth(1);
        $active_sheet->getPageSetup()->setFitToHeight(0);

        //eliminamos la hojas que no tienen consultorios (3 hojas=2 cons fisicos+1 virtual)
        for ($a = $i; $a <= 2; $a++) {
            $objPHPExcel->removeSheetByIndex($i);
        }

        $objPHPExcel->setActiveSheetIndex(0);



        // Write out as the new file
        $outputFileType = $inputFileType;
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, $outputFileType);

        $fecha_actual = date("Y-m-d__H-i");
        //header('Content-Type: application/vnd.ms-excel');
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . "agenda-" . $fecha_actual . '.xlsx"');
        header('Cache-Control: max-age=0');
        $objWriter->save('php://output');
    }

    /**
     *  metodo que devuelve la cantidad de turnos pendientes para un medico
     * @return int
     */
    public function getCantidadTurnosPendientes() {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad_turnos_pendientes");
        $query->setFrom("$this->table t");
        $query->setWhere("t.medico_idmedico = $idmedico");
        $query->addAnd("t.estado = 0");
        $query->addAnd("t.paciente_idpaciente is not null");
        $query->addAnd("CONCAT(t.fecha,' ',t.horarioInicio) > Date_format(now(),'%Y-%m-%d %H:%i:%s')");
        $rdo = $this->db->Execute($query->getSql())->FetchRow();
        if (!$rdo) {
            return 0;
        } else {
            return $rdo["cantidad_turnos_pendientes"];
        }
    }

    /**
     * metodo que obtiene el proximo turno para un medico
     * @return int
     */
    public function getProximoTurnoPendiente() {

        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $query = new AbstractSql();
        $query->setSelect(" *,  Date_format(t.fecha,'%d/%m/%Y') as fecha_formateada");
        $query->setFrom("$this->table t");
        $query->setWhere("t.medico_idmedico = $idmedico");
        $query->addAnd("t.estado = 0");
        $query->addAnd("t.paciente_idpaciente is not null");
        $query->addAnd("CONCAT(t.fecha,' ',t.horarioInicio) > Date_format(now(),'%Y-%m-%d %H:%i:%s')");
        $query->setOrderBy("t.fecha asc");
        $query->setLimit("1");
        $rdo = $this->db->Execute($query->getSql())->FetchRow();
        if (!$rdo) {
            return 0;
        } else {
            return $rdo;
        }
    }

    /**
     *  metodo para cambiar la disponibilidad del turno a inactivo o disponible
     */
    public function cambiarDisponibilidad($request) {

        $idturno = $request["idturno"];
        $turno = $this->get($idturno);
//controlamos que el turno sea del medico
        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
        if ($turno["medico_idmedico"] != $idmedico) {
            $this->setMsg(["msg" => "No se ha podido modificar la disponibilidad.", "result" => false]);
            return false;
        }
        //seteamos el estado del turno
        if ($turno["estado"] == '0') {
            $estado["estado"] = '8';
        } else {
            $estado["estado"] = '0';
        }
        //verificamos que no haya paciente asignado al turno
        if ($turno["paciente_idpaciente"] == "") {

            $this->db->StartTrans();
            $rdo = parent::update($estado, $idturno);
            $this->db->CompleteTrans();

            if ($rdo) {

                $this->setMsg(["msg" => "Se ha modificado correctamente la disponibilidad.", "result" => true]);
                return true;
            } else {

                $this->setMsg(["msg" => "No se ha podido modificar la disponibilidad.", "result" => false]);
                return false;
            }
        } else {

            $this->setMsg(["msg" => "Paciente asignado, no se puede modificar.", "result" => false]);
        }
    }

}

//END_class
?>