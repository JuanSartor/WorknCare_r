<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los posibles futuros pacientes que va a invitar el médicoe
 *
 */
class ManagerMedicoPacienteInvitacion extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "medico_paciente_invitacion", "idmedico_paciente_invitacion");
    }

    /**
     * Método que realiza el procesamiento de la invitación a un paciente..
     * Este paciente puede pertenecer a DP o puede ser un nuevo paciente
     * @param type $request
     * @return boolean
     */
    public function processInvitacion($request) {

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

        $request["ultimoenvio"] = date("Y-m-d");


        $array_datos = array("apellido");
        //Validar Mail
        //Validar EDAD
        //Recorro los datos obligatorios porque no viene un ID de paciente
        foreach ($array_datos as $key => $value) {
            if (!isset($request[$value]) || $request[$value] == "") {
                $this->setMsg(["msg" => "Error. Ingrese los campos obligatorios", "result" => false]);
                return false;
            }
        }

        if ($request["email"] == "" && $request["celular"] == "") {
            $this->setMsg(["msg" => "Error. Ingrese los campos obligatorios", "result" => false]);
            return false;
        }

        $request["medico_cabecera"] = $request["medico_cabecera"] == "" ? 0 : 1;
        if ($request["email"] != "") {


            //verificar invitacion pendiente
            //verificamos que si existe un paciente con ese email
            $usuario = $this->getManager("ManagerUsuarioWeb")->getByField("email", $request["email"]);
            if ($usuario) {
                $paciente = $this->getManager("ManagerPaciente")->getByField("usuarioweb_idusuarioweb", $usuario["idusuarioweb"]);
                if ($paciente) {



                    $mi_paciente = $this->getManager("ManagerMedicoMisPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $request["medico_idmedico"]]);

                    if ($mi_paciente) {

                        $this->setMsg(["result" => true, "msg" => "El paciente ya se encuentra agregado a su listado de pacientes", "email" => $request["email"], "celular" => $request["celular"]]);
                        return false;
                    } else {
                        //verificar si ya tienen un medico de cabecera
                        if ($request["medico_cabecera"] == 1) {
                            $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
                            if ($prof_frecuente) {
                                $this->setMsg(["result" => false, "msg" => "Error. El paciente ya posee un médico de cabecera"]);
                                return false;
                            }
                        }

                        $invitacion_pendiente = $this->getByFieldArray(["medico_idmedico", "email", "estado"], [$request["medico_idmedico"], $request["email"], 0]);
                        if ($invitacion_pendiente) {
                            return $this->reenviar_invitacion_paciente(["id" => $invitacion_pendiente[$this->id]]);
                        }

                        $rdo = parent::process($request);

                        $insert_mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $request["medico_idmedico"], "paciente_idpaciente" => $paciente["idpaciente"], "medico_cabecera" => $request["medico_cabecera"]]);
                        if (!$insert_mis_pacientes) {
                            $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar la solicitud"]);
                            return false;
                        }
                        //si el paciente existe, marcamos la invitacion como confirmada
                        $upd = parent::update(["estado" => 1], $rdo);
                    }
                }
            } else {

                $invitacion_pendiente = $this->getByFieldArray(["medico_idmedico", "email", "estado"], [$request["medico_idmedico"], $request["email"], 0]);
                if ($invitacion_pendiente) {
                    return $this->reenviar_invitacion_paciente(["id" => $invitacion_pendiente[$this->id]]);
                }

                $rdo = parent::process($request);
            }
            //Si se procesó correctamente envio de la invitacion por mail
            $request[$this->id] = $rdo;

            $envioEmail = $this->enviarEmailInvitacion($request);
            if ($request["celular"] != "") {
                $envioSMS = $this->sendSMSInvitacion($request);
            }
        } else {
            if ($request["celular"] != "") {
                $paciente = $this->getManager("ManagerPaciente")->getByField("numeroCelular", $request["celular"]);
                if ($paciente) {

                    $mi_paciente = $this->getManager("ManagerMedicoMisPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $request["medico_idmedico"]]);

                    if ($mi_paciente) {

                        $this->setMsg(["result" => true, "msg" => "El paciente ya se encuentra agregado a su listado de pacientes", "email" => $request["email"], "celular" => $request["celular"]]);
                        return false;
                    } else {
                        //verificar si ya tienen un medico de cabecera
                        if ($request["medico_cabecera"] == 1) {
                            $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
                            if ($prof_frecuente) {
                                $this->setMsg(["result" => false, "msg" => "Error. El paciente ya posee un médico de cabecera"]);
                                return false;
                            }
                        }

                        $invitacion_pendiente = $this->getByFieldArray(["medico_idmedico", "celular", "estado"], [$request["medico_idmedico"], $request["email"], 0]);
                        if ($invitacion_pendiente) {
                            return $this->reenviar_invitacion_paciente(["id" => $invitacion_pendiente[$this->id]]);
                        }

                        $rdo = parent::process($request);

                        $insert_mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $request["medico_idmedico"], "paciente_idpaciente" => $paciente["idpaciente"], "medico_cabecera" => $request["medico_cabecera"]]);
                        if (!$insert_mis_pacientes) {
                            $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar la solicitud"]);
                            return false;
                        }
                        //si el paciente existe, marcamos la invitacion como confirmada
                        $upd = parent::update(["estado" => 1], $rdo);

                        $envioSMS = $this->sendSMSInvitacion($request);
                    }
                }
            }
        }





        if ($paciente) {
            //Generar Notification -> de tipo "INFO DP"   
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $request["idmedico_paciente_invitacion"] = $rdo;
            $request["paciente_idpaciente"] = $paciente["idpaciente"];
            $rdo_notificacion = $ManagerNotificacion->createNotificacionFromMisPacientesInvitacion($request);
        }

        // <-- LOG
        $log["data"] = "Add name, email or tel, info medecin traitant";
        $log["page"] = "My patients";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "Create patient invitation";

        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // 

        if ($insert_mis_pacientes) {
            $this->setMsg(["result" => true, "msg" => "El paciente ha sido agregado a su listado de pacientes", "email" => $request["email"], "celular" => $request["celular"]]);
            return true;
        } else {
            $this->setMsg(["result" => true, "msg" => "Su solicitud ha sido enviada", "email" => $request["email"], "celular" => $request["celular"]]);
            return true;
        }
    }

    /**
     * Listado paginado a mis pacientes
     * @param array $request
     * @param type $idpaginate
     */
    public function getListadoPacientesInviacionPendiente() {




        $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];



        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom(" medico_paciente_invitacion mpi");

        $query->setWhere("mpi.medico_idmedico = $idmedico  AND mpi.paciente_idpaciente IS NULL AND mpi.estado = 0");



        $query->setOrderBy("mpi.ultimoenvio ASC");

        $listado = $this->getList($query);

        return $listado;
    }

    /**
     * Envío del email y la invitación 
     * @param type $request
     */
    public function enviarEmailInvitacion($request) {
        $smarty = SmartySingleton::getInstance();

        //Puede ser que se le envíe la invitación a un paciente  que ya se encuentra registrado en DP
        if ($request["paciente_idpaciente"] != "") {
            //Si viene el ID del paciente le tengo que enviar al paciente..
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);
            if ($paciente) {

                $request["apellido"] = $paciente["apellido"] . " " . $paciente["nombre"];
            }

            //Quiere decir que no es paciente titular
            if ($paciente["usuarioweb_idusuarioweb"] == "") {
                //Obtengo el paciente titular para el envío del email
                $paciente_titular = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);
                $request["email"] = $paciente_titular["email"];
            } else {
                $request["email"] = $paciente["email"];
            }
        }



        $medico = $this->getManager("ManagerMedico")->get($request["medico_idmedico"], true);
        $titulo_profesional = $this->getManager("ManagerTituloProfesional")->get($medico["titulo_profesional_idtitulo_profesional"]);

        $asunto = "WorknCare | ";

        if ($medico["titulo_profesional"]["titulo_profesional"] != "") {
            $asunto .= $medico["titulo_profesional"]["titulo_profesional"] . " ";
        }

        if ($medico["mis_especialidades"][0]["tipo"] == 2 && $medico["mis_especialidades"][0]["tipo_identificacion"] == 2) {
            $label_paciente = "clients";
        } else {
            $label_paciente = "patients";
        }

        $asunto .= $medico["nombre"] . " " . $medico["apellido"] . " souhaite vous ajouter à ses {$label_paciente}";



        $smarty->assign("medico", $medico);
        $smarty->assign("email", $request["email"]);
        $smarty->assign("nombre_apellido", $request["apellido"]);
        $smarty->assign("titulo_profesional", $titulo_profesional);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail = $this->getManager("ManagerMail");

        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");

        $mEmail->setSubject($asunto);

        $mEmail->setBody($smarty->Fetch("email/invitacion_registro_paciente.tpl"));

        $mEmail->addTo($request["email"]);

        if ($mEmail->send()) {

            $registro = $this->get($request[$this->id]);
            if ($registro) {
                $update = parent::update(["reintentos" => (int) $registro["reintentos"] + 1, "ultimoenvio" => date("Y-m-d H:i:s")], $request[$this->id]);
            }

            $this->setMsg(["result" => true, "msg" => "Invitacíon enviada con éxito"]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "ATENCION: No se pudo enviar la invitación"]);
            return false;
        }
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
                    $this->setMsg(["msg" => "Error. No se pudo eliminar la invitación. Intente más tarde", "result" => false]);
                    return false;
                }
            }

            $delete = parent::delete($request["id"], true);

            if ($delete) {
                $this->setMsg(["msg" => "La invitación fue eliminada con éxito", "result" => true]);
                return true;
            }
        }
        $this->setMsg(["msg" => "Error. No se pudo eliminar la invitación. Intente más tarde", "result" => false]);
        return false;
    }

    /**
     * Mpétodo que realiza el envío de la información sobre la invitación al paciente seleccionado mediante mensaje de texto
     * @param type $request
     * @return boolean
     */
    public function sendSMSInvitacion($request) {
        //Puede ser que se le envíe la invitación a un paciente  que ya se encuentra registrado en DP
        if ($request["paciente_idpaciente"] != "") {
            //Si viene el ID del paciente le tengo que enviar al paciente..
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->get($request["paciente_idpaciente"]);


            //Quiere decir que no es paciente titular
            if ($paciente["usuarioweb_idusuarioweb"] == "") {
                //Obtengo el paciente titular para el envío del sms
                $paciente_titular = $ManagerPaciente->getPacienteTitular($request["paciente_idpaciente"]);
                if ($paciente_titular["celularValido"] == 0) {
                    return false;
                } else {
                    $request["celular"] = $paciente_titular["numeroCelular"];
                }
            } else {
                //Es el paciente titular el seleccionado para enviar la invitación, entonces ya tiene celular
                if ($paciente["celularValido"] == 0) {
                    return false;
                } else {
                    $request["celular"] = $paciente["numeroCelular"];
                }
            }
        } else {
            //No es invitación a un paciente, entonces tengo que corroborar que el médico haya ingresado un celular para enviarle un mensaje
            if ($request["celular"] == "") {
                return false;
            }
        }

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($request["medico_idmedico"], true);

        $cuerpo = "";

        if ($medico["titulo_profesional"]["titulo_profesional"] != "") {
            $cuerpo .= $medico["titulo_profesional"]["titulo_profesional"] . " ";
        }

        if ($medico["mis_especialidades"][0]["tipo"] == 2 && $medico["mis_especialidades"][0]["tipo_identificacion"] == 2) {
            $label_paciente = "clients";
        } else {
            $label_paciente = "patients";
        }
        $cuerpo .= $medico["nombre"] . " " . $medico["apellido"] . " vous a envoyé une invitation sur WorknCare. Inscrivez-vous en vous connectant à: " . URL_ROOT . "patient/creer-un-compte.html";

        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => 'P',
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $medico["idmedico"],
            "contexto" => "Invitación a paciente",
            "texto" => $cuerpo,
            "numero_cel" => $request["celular"]
        ]);


        if ($sms) {
            $this->setMsg(["msg" => "Se ha enviado un SMS a su celular.", "result" => true]);
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
        if ($request["idnotificacion"] != "") {
            $notificacion = $ManagerNotificacion->get($request["idnotificacion"]);
            //Obtengo el registro de Médico Paciente Invitación
            $registro = $this->get($notificacion["medico_paciente_invitacion_idmedico_paciente_invitacion"]);
        } else if ($request["idmedico_paciente_invitacion"] != "") {
            $registro = $this->get($request["idmedico_paciente_invitacion"]);
        }

        if ($registro) {

            if ((int) $registro["estado"] != 0) {
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                //$estado = (int) $registro["estado"] == 1 ? "" : "";
                if ($registro["estado"] == 1) {
                    $this->setMsg(["msg" => "Error. Ya aceptó la petición del médico.", "result" => false]);
                } else {
                    $this->setMsg(["msg" => "Error. Ya rechazó la petición del médico.", "result" => false]);
                }

                return false;
            }

            if ($registro) {

                $estado = (int) $request["estado"] == 1 ? 1 : 2;
                //Actualizo la invitación del paciente -> 1 = aceptado <-> 2 = rechazado
                $update = parent::update(["estado" => $estado], $registro[$this->id]);
                if ($update) {

                    //Si el paciente lo acepta, tengo que crear la relacion entre el médico
                    $ManagerPaciente = $this->getManager("ManagerPaciente");
                    if (CONTROLLER == "paciente_p") {
                        $paciente = $ManagerPaciente->getPacienteXHeader();
                    } else {
                        $paciente = $ManagerPaciente->get($request["idpaciente"]);
                    }

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

                            $this->setMsg(["result" => true, "msg" => "Se le ha enviado una notificación con la respuesta al médico"]);
                            $this->db->CompleteTrans();
                            return $update;
                        }
                    }
                }
            }
        }
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => "Error. No se pudo procesar la respuesta a la invitación.", "result" => false]);
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
        $query->addAnd("estado = 0");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            foreach ($listado as $key => $invitacion) {
                //Tengo que crear la notificación de invitación
                $invitacion["paciente_idpaciente"] = $request["idpaciente"];
                $ManagerNotificacion->createNotificacionFromMisPacientesInvitacion($invitacion);
                $this->processRespuestaPaciente(["estado" => 1, "idmedico_paciente_invitacion" => $invitacion["idmedico_paciente_invitacion"], "idpaciente" => $request["idpaciente"]]);
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
     * @param type $idpaciente
     * @return type
     */
    public function verificar_invitacion_pendiente($idmedico, $idpaciente) {

        //verififco si hay invitacion id;
        $invitacion = $this->getXRelacion($idmedico, $idpaciente);
        if ($invitacion) {
            //si hay una invitacion pendiente la actualizo
            if ($invitacion["estado"] == 0) {
                parent::update(["estado" => 1], $invitacion[$this->id]);
            }
        }
        return true;
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
     * Método que reenvia una invitacion existente de un medico a un paciente..
     * 
     * @param type $request
     * @return boolean
     */
    public function reenviar_invitacion_paciente($request) {

        $invitacion_pendiente = parent::get($request["id"]);

        //verificar invitacion pendiente
        if (!$invitacion_pendiente) {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la invitación"]);
            return false;
        }
        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        $request["ultimoenvio"] = date("Y-m-d H:i:s");

        //verificamos que si existe un paciente con ese email
        $usuario = $this->getManager("ManagerUsuarioWeb")->getByField("email", $invitacion_pendiente["email"]);
        if ($usuario) {
            $paciente = $this->getManager("ManagerPaciente")->getByField("usuarioweb_idusuarioweb", $usuario["idusuarioweb"]);
            if ($paciente) {
                $mi_paciente = $this->getManager("ManagerMedicoMisPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $request["medico_idmedico"]]);
                if ($mi_paciente) {
                    //si el paciente existe, marcamos la invitacion como confirmada
                    $upd = parent::update(["estado" => 1], $request["id"]);
                    $this->setMsg(["result" => true, "msg" => "El paciente ya se encuentra agregado a su listado de pacientes", "email" => $invitacion_pendiente["email"], "celular" => $invitacion_pendiente["celular"]]);
                    return false;
                } else {
                    $insert_mis_pacientes = $this->getManager("ManagerMedicoMisPacientes")->insert(["medico_idmedico" => $request["medico_idmedico"], "paciente_idpaciente" => $paciente["idpaciente"]]);
                    if (!$insert_mis_pacientes) {
                        $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar la solicitud"]);
                        return false;
                    }
                    //si el paciente existe, marcamos la invitacion como confirmada
                    $upd = parent::update(["estado" => 1], $request["id"]);
                }
            }
        }

        //Si se procesó correctamente envio de la invitacion por mail
        $request[$this->id] = $invitacion_pendiente[$this->id];

        $envioEmail = $this->enviarEmailInvitacion($invitacion_pendiente);

        $envioSMS = $this->sendSMSInvitacion($invitacion_pendiente);


        if ($paciente) {
            //Generar Notification -> de tipo "INFO DP"   
            $ManagerNotificacion = $this->getManager("ManagerNotificacion");
            $request["idmedico_paciente_invitacion"] = $invitacion_pendiente[$this->id];
            $request["paciente_idpaciente"] = $paciente["idpaciente"];
            $rdo_notificacion = $ManagerNotificacion->createNotificacionFromMisPacientesInvitacion($request);
        }
        $upd = parent::update(["ultimoenvio" => $request["ultimoenvio"]], $invitacion_pendiente[$this->id]);


        if ($upd) {
            if ($insert_mis_pacientes) {
                $this->setMsg(["result" => true, "msg" => "El paciente ha sido agregado a su listado de pacientes", "email" => $invitacion_pendiente["email"], "celular" => $invitacion_pendiente["celular"]]);
                return true;
            } else {
                $this->setMsg(["result" => true, "msg" => "Su solicitud ha sido enviada", "email" => $invitacion_pendiente["email"], "celular" => $invitacion_pendiente["celular"]]);
                return true;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar la solicitud"]);
            return false;
        }
    }

}

//END_class
?>