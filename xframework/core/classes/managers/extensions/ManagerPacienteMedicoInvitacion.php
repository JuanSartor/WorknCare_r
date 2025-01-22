<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los posibles futuros pacientes que va a invitar al médico
 *
 */
class ManagerPacienteMedicoInvitacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "paciente_medico_invitacion", "idpaciente_medico_invitacion");
    }

    /**
     * Método que realiza el procesamiento de la invitación de un paciente a un medico frecuente..
     * 
     * @param type $request
     * @return boolean
     */
    public function invitar_medico($request) {
        if ($request["especialidad_idespecialidad"] == "" || $request["nombre"] == "" || ($request["email"] == "" && $request["celular"] == "")) {
            $this->setMsg([ "result" => false, "msg" => "Complete los datos obligatorios"]);
            return false;
        }

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $request["paciente_idpaciente"] = $paciente["idpaciente"];
        if ($request["especialidad_idespecialidad"] == "-1") {
            $request["medico_cabecera"] = 1;
            unset($request["especialidad_idespecialidad"]);

            //verificar si ya tienen un medico de cabecera
            $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
            if ($prof_frecuente) {
                $this->setMsg([ "result" => false, "msg" => "Error. Ya posee un médico de cabecera"]);
                return false;
            }
        }

        $request["creacion"] = $request["ultimoenvio"] = date("Y-m-d H:i:s");
        $invitacion_exist = $this->getByFieldArray(["email", "estado"], [$request["email"], 0]);
        if ($invitacion_exist) {
            $this->setMsg([ "result" => false, "msg" => "El profesional tiene una invitación de registro pendiente"]);
            return false;
        }
        //verififacmos si ya esta registrado con ese mail
        $usuario_exist = $this->getManager("ManagerUsuarioWeb")->getByFieldArray(["email", "registrado"], [$request["email"], 1]);
        $this->db->StartTrans();
        if ($usuario_exist) {
            if ($usuario_exist["tipousuario"] == "paciente") {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Error. El email ingresado pertenece a un paciente registrado en DoctorPlus"]);
                return false;
            }

            $medico = $this->getManager("ManagerMedico")->getByField("usuarioweb_idusuarioweb", $usuario_exist["idusuarioweb"]);
            $request["medico_idmedico"] = $medico["idmedico"];


            $profesional_frec_exits = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $medico["idmedico"]]);
            if ($profesional_frec_exits) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Error. El profesional ingresado ya pertenece sus profesionales frecuentes"]);
                return false;
            }
            $preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);

            //si ya existe y tiene la tarifas completas
            if ($preferencia["valorPinesConsultaExpress"] != "" && $preferencia["valorPinesVideoConsulta"] != "" && $preferencia["valorPinesVideoConsultaTurno"] != "") {
                $medico_existente_agregado = true;
                $record["paciente_idpaciente"] = $paciente["idpaciente"];
                $record["medico_idmedico"] = $medico["idmedico"];
                $record["medico_cabecera"] = $request["medico_cabecera"];
                $prof_frecuentes = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert($record);

                if (!$prof_frecuentes) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }

                if ($request["medico_cabecera"] == 1) {
                    $this->getManager("ManagerPaciente")->basic_update(["medico_cabeza" => 1], $paciente["idpaciente"]);
                }

                $notificacion = $this->getManager("ManagerNotificacion")->createNotificacionRespuestaAgregarProfesionalFrecuente($record);
                if (!$notificacion) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }

                $notificacion_medico = $this->getManager("ManagerNotificacion")->createNotificacionAgregarProfesionalFrecuente($request);
                if (!$notificacion_medico) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }
                //ya marcamos la invitacion como aceptada
                $request["estado"] = 1;
            }
        }

        //Cuando no Existe el paciente
        //Envío mail o envío celular (fijarse Si tiene celular válido)


        $rdo = parent::process($request);

        // <-- LOG
        $log["data"] = "Date and time request, specialty, name profesional";
        $log["page"] = "Home page (connected)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Send invitation to Frequent Professional";    

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 
            
        if ($rdo) {
            
            
            
            
            if ($request["email"] != "") {
                $envioEmail = $this->enviarEmailInvitacion($request);
            }
            if ($request["celular"] != "") {
                $envioSMS = $this->sendSMSInvitacion($request);
            }

            if ($medico_existente_agregado) {
                $this->setMsg([ "result" => true, "msg" => "El profesional ha sido agregado a sus Profesionales Frecuentes"]);
            } else {
                $this->setMsg([ "result" => true, "msg" => "Su invitación ha sido enviada"]);
            }
            $this->db->CompleteTrans();
            return $rdo;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg([ "result" => false, "msg" => "Error. No se pudo enviar la invitación"]);
            return false;
        }
    }

    /**
     * Método que reenvia una invitacion existente de un paciente a un medico frecuente..
     * 
     * @param type $request
     * @return boolean
     */
    public function reenviar_invitacion_medico($request) {

        $invitacion = parent::get($request["id"]);
        if (!$invitacion) {
            $this->setMsg([ "result" => false, "msg" => "Error. No se pudo recuperar la invitación"]);
            return false;
        }

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $request["paciente_idpaciente"] = $paciente["idpaciente"];
        //verififacmos si ya esta registrado con ese mail
        $usuario_exist = $this->getManager("ManagerUsuarioWeb")->getByFieldArray(["email", "registrado"], [$invitacion["email"], 1]);
        $this->db->StartTrans();
        if ($usuario_exist) {

            if ($usuario_exist["tipousuario"] == "paciente") {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Error. El email ingresado pertenece a un paciente registrado en DoctorPlus"]);
                return false;
            }
            $medico = $this->getManager("ManagerMedico")->getByField("usuarioweb_idusuarioweb", $usuario_exist["idusuarioweb"]);


            $request["medico_idmedico"] = $medico["idmedico"];

            $profesional_frec_exits = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $medico["idmedico"]]);
            if ($profesional_frec_exits) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Error. El profesional ingresado ya pertenece sus profesionales frecuentes"]);
                return false;
            }
            $preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);

            //si ya existe
            if ($preferencia["valorPinesConsultaExpress"] != "" && $preferencia["valorPinesVideoConsulta"] != "" && $preferencia["valorPinesVideoConsultaTurno"] != "") {
                $medico_existente_agregado = true;
                $record["paciente_idpaciente"] = $paciente["idpaciente"];
                $record["medico_idmedico"] = $medico["idmedico"];
                $record["medico_cabecera"] = $invitacion["medico_cabecera"];
                $prof_frecuentes = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->insert($record);
                if (!$prof_frecuentes) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }
                if ($request["medico_cabecera"] == 1) {
                    $this->getManager("ManagerPaciente")->basic_update(["medico_cabeza" => 1], $paciente["idpaciente"]);
                }

                $notificacion = $this->getManager("ManagerNotificacion")->createNotificacionRespuestaAgregarProfesionalFrecuente($record);
                if (!$notificacion) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }
                $notificacion_medico = $this->getManager("ManagerNotificacion")->createNotificacionAgregarProfesionalFrecuente($request);
                if (!$notificacion_medico) {
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                    return false;
                }
                //ya marcamos la invitacion como aceptada
                $request["estado"] = 1;
            }
        }

        $request["ultimoenvio"] = date("Y-m-d H:i:s");
        $request["reintentos"] = $invitacion["reintentos"] + 1;


        $rdo = parent::update($request, $request["id"]);

        if ($rdo) {

            // <-- LOG
            $log["data"] = "specialty, name, email or celular";
            $log["page"] = "Home page (connected)";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "Resend invitation to Professional";    

            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            //
                
            if ($invitacion["email"] != "") {
                $envioEmail = $this->enviarEmailInvitacion($invitacion);
            }
            if ($invitacion["celular"] != "") {
                $envioSMS = $this->sendSMSInvitacion($invitacion);
            }

            $this->db->CompleteTrans();
            if ($medico_existente_agregado) {
                $this->setMsg([ "result" => true, "msg" => "El profesional ha sido agregado a sus Profesionales Frecuentes"]);
            } else {
                $this->setMsg([ "result" => true, "msg" => "Su invitación ha sido enviada"]);
            }
            return $rdo;
        } else {
            $this->db->FailTrans();
            $this->db->CompleteTrans();
            $this->setMsg([ "result" => false, "msg" => "Error. No se pudo enviar la invitacion"]);
            return false;
        }
    }

    public function getListadoInvitaciones($solo_pendientes = false) {
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

        $query = new AbstractSql();
        $query->setSelect("t.*,e.especialidad");
        $query->setFrom("$this->table t
                left join especialidad e on (e.idespecialidad=t.especialidad_idespecialidad)");
        $query->setWhere("paciente_idpaciente =" . $paciente["idpaciente"]);
        if ($solo_pendientes) {
            $query->addAnd("estado=0");
        }


        $listado = $this->getList($query);

        return $listado;
    }

    /**
     * Envío del email y la invitación 
     * @param type $request
     */
    public function enviarEmailInvitacion($request) {
        $smarty = SmartySingleton::getInstance();


        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

        $smarty->assign("nombre", $request["nombre"]);
        $smarty->assign("email", $request["email"]);
        $smarty->assign("paciente", $paciente);

        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject("WorknCare | Votre patient souhaite vous ajouter à ses Professionnels Fréquents");

        $mEmail->setBody($smarty->Fetch("email/invitacion_registro_medico.tpl"));

        $mEmail->addTo($request["email"]);

        if ($mEmail->send()) {

            $this->setMsg(["result" => true, "msg" => "Invitacíon enviada con éxito"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "ATENCION: No se pudo enviar la invitación"]);
            return false;
        }
    }
    
    public function delete($id, $force) {
        
        // <-- LOG
        $log["data"] = "Date, time request, specialty, name profesional";
        $log["page"] = "Home page (connected)";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Delete Invitation to Frequent Professional";    

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        //
        parent::delete($id, $force);
    }

    /**
     * Eliminación de la asociación. 
     * @param type $request
     * @return boolean
     */
    public function deleteAsociacion($request) {

        $registro = parent::get($request["id"]);

        if ($registro) {

            //Elimino la notificación generada por el médico al invitar al paciente
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $notificacion = $ManagerNotificacion->getByField("medico_paciente_invitacion_idmedico_paciente_invitacion", $request["id"]);
            if ($notificacion) {
                //Debo eliminar la notificacion
                $notificacion_eliminada = $ManagerNotificacion->delete($notificacion["idnotificacion"]);
                if (!$notificacion_eliminada) {
                    $this->setMsg([ "msg" => "Error. No se pudo eliminar la invitación. Intente más tarde", "result" => false]);
                    return false;
                }
            }

            $delete = parent::delete($request["id"], true);

            if ($delete) {
                $this->setMsg([ "msg" => "La invitación fue eliminada con éxito", "result" => true]);
                return true;
            }
        }
        $this->setMsg([ "msg" => "Error. No se pudo eliminar la invitación. Intente más tarde", "result" => false]);
        return false;
    }

    /**
     * Mpétodo que realiza el envío de la información sobre la invitación al paciente seleccionado mediante mensaje de texto
     * @param type $request
     * @return boolean
     */
    public function sendSMSInvitacion($request) {

        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

        $cuerpo = "Le patient ";

        $cuerpo.=$paciente["nombre"] . " " . $paciente["apellido"] . " souhaite vous ajouter à ses Professionnels Fréquents. Inscrivez-vous en vous connectant à " . URL_ROOT;

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'M',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => "",
            "contexto" => "Invitación a médico frecuente",
            "texto" => $cuerpo,
            "numero_cel" => $request["celular"]
        ]);


        if ($sms) {
            $this->setMsg([ "msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
            return true;
        } else {
            $this->setMsg($ManagerLogSMS->getMsg());

            return false;
        }
    }

    /*     * Metodo que valida si el medico ya a enviado una invitacion de registro a ese paciente
     * 
     * @param type $request
     * @return type
     */

    public function verificarPacienteInvitado($request) {
        $rs = $this->db->GetRow("select count(*) as qty  from medico_paciente_invitacion 
                                where email='" . $request["email"] . "'
                                and medico_idmedico=" . $request["medico_idmedico"] . "
                                and estado=0");

        return $rs["qty"] > 0;
    }

    /**
     * Método que procesa la respuesta del paciente ante la invitación del médico 
     * @param type $request
     * @return boolean
     */
    public function processRespuestaPaciente($request) {

        $this->db->StartTrans();
        //Obtengo la notificación correspondiente a la invitación del médico
        $ManagerNotificacion = $this->getManager("ManagerNotificacion");
        $notificacion = $ManagerNotificacion->get($request["idnotificacion"]);

        if ($notificacion) {
            //Obtengo el registro de Médico Paciente Invitación
            $registro = $this->get($notificacion["medico_paciente_invitacion_idmedico_paciente_invitacion"]);

            if ((int) $registro["estado"] != 0) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $estado = (int) $registro["estado"] == 1 ? "aceptó" : "rechazó";
                $this->setMsg([ "msg" => "Error. Ya $estado la petición del médico.", "result" => false]);
                return false;
            }

            if ($registro) {

                $estado = (int) $request["estado"] == 1 ? 1 : 2;
                //Actualizo la invitación del paciente -> 1 = aceptado <-> 2 = rechazado
                $update = parent::update(["estado" => $estado], $registro[$this->id]);
                if ($update) {

                    //Si el paciente lo acepta, tengo que crear la relacion entre el médico
                    $ManagerPaciente = $this->getManager("ManagerPaciente");
                    $paciente = $ManagerPaciente->getPacienteXHeader();

                    if ($estado == 1) {
                        //Tengo que crear la relación entre médicos /mis pacientes
                        $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
                        $insert_asociacion = [
                            "paciente_idpaciente" => $paciente["idpaciente"],
                            "medico_idmedico" => $registro["medico_idmedico"]
                        ];

                        $process_medico_mis_pacientes = $ManagerMedicoMisPacientes->process($insert_asociacion);
                    }


                    if (($process_medico_mis_pacientes && $estado == 1) || $estado == 2) {
                        $request["medico_idmedico"] = $registro["medico_idmedico"];
                        $request["paciente_idpaciente"] = $paciente["idpaciente"];
                        //Creo la notificación
                        $crear_notificacion = $ManagerNotificacion->createNotificacionFromMisPacientesRespuesta($request);

                        if ($crear_notificacion) {

                            $this->setMsg([ "result" => true, "msg" => "Se le ha enviado una notificación con la respuesta al médico"]);
                            $this->db->CompleteTrans();
                            return $update;
                        }
                    }
                }
            }
        }
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg([ "msg" => "Error. No se pudo procesar la respuesta a la invitación.", "result" => false]);
        return false;
    }

    /**
     * Método que chequea si el paciente logueado fue invitado por algún médico.. 
     * Si fue invitado por un médico se crea la notificación al paciente pidiendo la solicitud para que forme parte de su lista de pacientes
     * @param type $request
     */
    public function checkPacienteInvitacionFromRegistro($request) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $email = $request["email"];
        $query->setWhere("email = '$email'");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            foreach ($listado as $key => $invitacion) {
                //Tengo que crear la notificación de invitación
                $invitacion["paciente_idpaciente"] = $request["idpaciente"];
                $ManagerNotificacion->createNotificacionFromMisPacientesInvitacion($invitacion);
            }

            return true;
        } else {
            return false;
        }
    }

    /**
     * Método que obtiene la relación del paciente en base al idmedico y el idpaciente
     * @param type $idmedico
     * @param type $idpaciente
     * @return type
     */
    public function getXRelacion($idmedico, $idpaciente) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico = $idmedico");
        $query->addAnd("paciente_idpaciente = $idpaciente");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Método que obtiene la relación del paciente en base al idmedico y el idpaciente
     * @param type $idmedico
     * @param type $email
     * @return type
     */
    public function getXRelacionEmail($idmedico, $email) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("medico_idmedico = $idmedico");
        $query->addAnd("email = '$email'");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Metodo que verifica las invitaciones a profesionales frecuentes y agrega la relacion con los pacientes cuando se completaron las tarifa
     */
    public function verificarInvitacionesProfesionalesFrecuentes($medico) {

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("$this->table");
        $query->setWhere("estado=0");
        $query->addAnd("(email='{$medico["email"]}') OR (celular='{$medico["numeroCelular"]}')");
        $listado_invitaciones = $this->getList($query);
        $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");
        $result = true;

        foreach ($listado_invitaciones as $invitacion) {
            $this->db->StartTrans();
            $record["paciente_idpaciente"] = $invitacion["paciente_idpaciente"];
            $record["medico_idmedico"] = $medico["idmedico"];
            $record["medico_cabecera"] = $invitacion["medico_cabecera"];
            $rdo1 = $ManagerProfesionalesFrecuentesPacientes->insert($record);
            $rdo2 = parent::update(["estado" => 1], $invitacion["idpaciente_medico_invitacion"]);
            //actualizamos la informacion personales
            if ($invitacion["medico_cabecera"] == 1) {
                $this->getManager("ManagerPaciente")->basic_update(["medico_cabeza" => 1], $invitacion["paciente_idpaciente"]);
            }
            $notificacion = $this->getManager("ManagerNotificacion")->createNotificacionRespuestaAgregarProfesionalFrecuente($record);
            if (!$notificacion) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                return false;
            }

            $notificacion_medico = $this->getManager("ManagerNotificacion")->createNotificacionAgregarProfesionalFrecuente($record);
            if (!$notificacion_medico) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "result" => false, "msg" => "Ocurrió un error al agregar el profesional frecuente"]);
                return false;
            }

            if (!$rdo1 || !$rdo2 || !$notificacion) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                $this->setMsg([ "msg" => "Error. No se pudo procesar la invitación.", "result" => false]);
                $result = false;
            }
            $this->db->CompleteTrans();
        }

        $this->setMsg([ "msg" => "Invitaciones procesadas con éxito", "result" => false]);
        return $result;
    }

}

//END_class
?>