<?php

/**
 * ManagerMensajeConsultaExpress administra los mensajes enviados entre medico y pacientes en una consulta express
 *
 * @author lucas
 */
class ManagerMensajeConsultaExpress extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "mensajeconsultaexpress", "idmensajeConsultaExpress");
    }

    /*     * Inserta un registro en la tabla correspondiente
     * 
     * @param type $request
     */

    public function basic_insert($request) {
        return parent::insert($request);
    }

    /*     * Metodo que inserta un registro cuando se envia un mensaje entre medico y paciente en una consulta express**
     * 
     */

    public function insert($request) {

        $consulta = $this->getManager("ManagerConsultaExpress")->get($request["consultaExpress_idconsultaExpress"]);

        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "4" || $consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "8") {

            $this->setMsg(["msg" => "No se pudo enviar el mensaje. La consulta ya ha sido finalizada", "result" => false
            ]);

            return false;
        }
        if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "5") {

            $this->setMsg(["msg" => "No se pudo enviar el mensaje. Ya pasó el período de publicación de la consulta", "result" => false]);

            return false;
        }

        $request["estadoConsultaExpress_idestadoConsultaExpress"] = $consulta["estadoConsultaExpress_idestadoConsultaExpress"];
        $procesar_diferencia = false;

        //verifiamos que la consulta pertenezca al paciente
        if (CONTROLLER == "paciente_p") {
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();

            $idpaciente = $paciente["idpaciente"];
            $request["paciente_idpaciente"] = $idpaciente;

            //validamos la consulta que pertenezca al paciente 

            if ($request["consultaExpress_idconsultaExpress"] == "" || $consulta["paciente_idpaciente"] != $idpaciente) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                return false;
            }
        }

        //verificamos que la consulta pertenezca al medico
        if (CONTROLLER == "medico") {
            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            $fecha_actual = strtotime(date("Y-m-d H:i:s"));
            $fecha_vencimiento = strtotime($consulta["fecha_vencimiento"]);
            $fecha_vencimiento_toma = strtotime($consulta["fecha_vencimiento_toma"]);

            if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1" && $fecha_actual > $fecha_vencimiento && ($consulta["tomada"] == "0" || $consulta["medico_idmedico"] != $idmedico)) {

                $this->setMsg(["msg" => "Error. Ya pasó el período de publicación de la consulta", "result" => false]);

                return false;
            }

            if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1" && $fecha_actual > $fecha_vencimiento_toma && $consulta["tomada"] == "1" && $consulta["medico_idmedico"] == $idmedico) {

                $this->setMsg(["msg" => "Error. Ya pasó su período de respuesta", "result" => false]);

                return false;
            }

            if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "9") {
                $this->setMsg(["msg" => "Error. Se produjo un error en la consulta express seleccionada", "result" => false]);

                return false;
            }
            //validamos la consulta que pertenezca al paciente 
            $consulta = $this->getManager("ManagerConsultaExpress")->get($request["consultaExpress_idconsultaExpress"]);

            if ($request["consultaExpress_idconsultaExpress"] == "" || $consulta["medico_idmedico"] != $idmedico) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                return false;
            }

            //Me fijo si se esta aceptando la consulta (primer mensaje), si la consulta pertenece a la red y si no es de un prestador
            if ($consulta["tipo_consulta"] == "0" && $consulta["prestador_idprestador"] == "" && $consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1") {
                $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                //si es paciente empresa y se debito consulta del plan empresa no hay que procesar diferencia de dinero
                if ($paciente["is_paciente_empresa"] == 1 && $consulta["debito_plan_empresa"] == 1) {
                    $procesar_diferencia = false;
                } else {
                    //Process movimiento de diferencia  entre lo que cobra el medico y lo que se desconto al paciente
                    $procesar_diferencia = true;
                }


                // <-- LOG
                $log["data"] = "date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
                $log["page"] = "Conseil";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Accept Conseil request RECEIVED";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }

            //agregamos a mis pacientes
            if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1") {
                $ManagerMedicoMisPacientes = $this->getManager("ManagerMedicoMisPacientes");
                $rdoMMP = $ManagerMedicoMisPacientes->process(["medico_idmedico" => $idmedico, "paciente_idpaciente" => $consulta["paciente_idpaciente"]]);
                if (!$rdoMMP) {
                    $this->setMsg($ManagerMedicoMisPacientes->getMsg());
                    return false;
                }
            }
        }
        if (isset($request["hash_audio"]) && $request["hash_audio"] != "" && $request["mensaje"] == "") {
            $request["mensaje"] = "Message vocal";
        }
        //agregar toda la logica necesaria
        if ($request["mensaje"] == "") {
            $this->setMsg(["msg" => "Ingrese el texto del mensaje", "result" => false]);
            return false;
        }




        $this->db->StartTrans();

        $request["fecha"] = date("Y-m-d H:i:s");
        $request["leido"] = 0;

        //seteamos quien es el emisor y el flag leido en 0 de la consulta express para que le aparezca la notificacion al receptor
        if (CONTROLLER == "medico") {
            $leido = "leido_paciente";
            $request["emisor"] = "m";
        }
        if (CONTROLLER == "paciente_p" || CONTROLLER == "paciente") {
            $leido = "leido_medico";
            $request["emisor"] = "p";
        }


        //actualizamos la consulta express para que se liste la notificacion del nuevo mensaje y aumentamos el tiempo de vencimiento
        if (CONTROLLER == "paciente_p" && $request["reenviar"] == "1") {
            $fecha_actual = date("Y-m-d H:i:s");
            if ($consulta["tipo_consulta"] == "0") {
                $fecha_vencimiento = strtotime("+" . VENCIMIENTO_CE_RED . " hour", strtotime($fecha_actual));
            } else {
                $fecha_vencimiento = strtotime("+" . VENCIMIENTO_CE_FRECUENTES . " hour", strtotime($fecha_actual));
            }
            $fecha_vencimiento = date("Y-m-d H:i:s", $fecha_vencimiento);
            $rdo1 = $this->db->Execute("update consultaexpress set fecha_ultimo_mensaje='" . $request["fecha"] . "', $leido=0, fecha_vencimiento='$fecha_vencimiento' where idconsultaExpress=" . $request["consultaExpress_idconsultaExpress"]);
        } else {
            //si el mensaje lo envia el medico solo actualizamos la fecha de ultimo mensaje y la establecemos con consulta abierta
            $rdo1 = $this->db->Execute("update consultaexpress set estadoConsultaExpress_idestadoConsultaExpress=2, fecha_ultimo_mensaje='" . $request["fecha"] . "', $leido=0 where idconsultaExpress=" . $request["consultaExpress_idconsultaExpress"]);
        }

        $rdo = parent::insert($request);

        if ($rdo && $rdo1) {
            $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
            $request["idmensajeConsultaExpress"] = $rdo;

            $process_images = $ManagerArchivosMensajeConsultaExpress->processAllFiles($request);
            if (!$process_images) {
                $this->setMsg(["msg" => "Error. No se pudo insertar el mensaje de la consulta express", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }

            /**
             * Relocalización del arcivho de audio perteneciente a un mensaje
             */
            if (isset($request["hash_audio"]) && $request["hash_audio"] != "" && $request["audio_msg"] == "1") {
                $path_audio = path_root("xframework/files/temp/audio/{$request["hash_audio"]}.mp3");
                //echo $path_audio;
                if (is_file($path_audio)) {
                    //seteo la variable del mail de mensaje que indica la presencia de un audio 
                    $request["audio_mail"] = 1;

                    $path_dir = path_entity_files("audios/{$request["consultaExpress_idconsultaExpress"]}");

                    if (!is_dir($path_dir)) {
                        $dir = new Dir($path_dir);
                        $dir->chmod(0777);
                    }
                    $new_audio = $path_dir . "/{$rdo}.mp3";
                    rename($path_audio, $new_audio);
                    if (!is_file($new_audio)) {
                        $this->setMsg(["msg" => "Error. No se ha podido enviar el mensaje.", "result" => false]);
                        $this->db->FailTrans();
                        $this->db->CompleteTrans();
                        return false;
                    }
                } else {
                    $this->setMsg(["msg" => "Error. No se ha podido enviar el mensaje.", "result" => false]);
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            if ($procesar_diferencia) {
                $ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
                $rdo1 = $ManagerMovimientoCuenta->processDiferenciaPublicacionCE($consulta);

                if (!$rdo1) {
                    $this->setMsg($ManagerMovimientoCuenta->getMsg());
                    $this->db->FailTrans();
                    $this->db->CompleteTrans();
                    return false;
                }
            }

            //si la consulta es dirigida a un medico y esta pendiente o abierta, o el medico contesta esta contestando, enviamos un mail al destinatario
            if ((CONTROLLER == "medico") || (CONTROLLER == "paciente_p" && $consulta["medico_idmedico"] != "" && ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1" || $consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "2"))) {
                //enviamos el mail de la consulta express del mensaje
                $mail = $this->enviarMailMensajeCE($request);
                $sms = $this->enviarSMSMensajeConsultaExpress($request["consultaExpress_idconsultaExpress"]);
            }

            if (CONTROLLER == "paciente_p") {
                // <-- LOG
                $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
                $log["page"] = "Conseil";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "Answer Conseil ONGOING";

                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // 
            }

            //realizamos el cobro en stripe -
            //cobrar al consultas particulares (en la red se cobra en la devolucion de diferencia)
            if (CONTROLLER == "medico" && $consulta["estadoConsultaExpress_idestadoConsultaExpress"] == "1" && $consulta["pago_stripe"] == "1" && $request["rechazar"] != "1") {
                $ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
                $confirmar_cobro = $ManagerCustomerStripe->confirmar_cobro_consulta($request["consultaExpress_idconsultaExpress"], "consultaexpress");
                if (!$confirmar_cobro) {
                    $this->setMsg($ManagerCustomerStripe->getMsg());
                    $this->db->FailTrans();
                    return false;
                }
            }

            $this->setMsg(["msg" => "Su mensaje se ha enviado con éxito.", "result" => true]);

            $this->db->CompleteTrans();

            if ($consulta["estadoConsultaExpress_idestadoConsultaExpress"] != "6") {
                $client = new XSocketClient();
                $client->emit("cambio_estado_consultaexpress_php", $consulta);
                if ($consulta["tipo_consulta"] == "0") {
                    $filtro = $this->getManager("ManagerFiltrosBusquedaConsultaExpress")->getByField("consultaExpress_idconsultaExpress", $consulta["idconsultaExpress"]);
                    $client->emit('cambio_estado_consultaexpress_red_php', ["idespecialidad" => $filtro["especialidad_idespecialidad"]]);
                }
                //notify
                $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Conseil";
                $notify["text"] = "Nouveau message";
                if (CONTROLLER == "medico") {
                    $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
                    $notify["type"] = "mensaje-ce-paciente";
                }
                if (CONTROLLER == "paciente_p") {
                    $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                    $notify["type"] = "mensaje-ce-medico";
                }

                $notify["id"] = $consulta["idconsultaExpress"];
                $notify["style"] = "consulta-express";
                $client->emit('notify_php', $notify);
            }

            if (isset($request["hash_audio"]) && $request["hash_audio"] != "") {
                $path_audio = path_root("xframework/files/temp/audio/{$request["hash_audio"]}.mp3");
                if (is_file($path_audio)) {
                    unlink($path_audio);
                }
            }

            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. No se ha podido enviar el mensaje.", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
    }

    /**
     * Mpétodo utilizado para clonar los mensajes desde otro mensaje
     * @param type $request
     */
    public function cloneMensaje($idmensajeToClone, $idconsultaExpress) {
        $mensaje = parent::get($idmensajeToClone);

        if ($mensaje) {
            $insert = $mensaje;

            unset($insert[$this->id]);
            $insert["consultaExpress_idconsultaExpress"] = $idconsultaExpress;
            $idmensajeNew = parent::insert($insert);

            if ($idmensajeNew) {
                /**
                 * Copio las imagenes
                 */
                $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
                $listado = $ManagerArchivosMensajeConsultaExpress->getListImages($mensaje[$this->id]);

                if ($listado && count($listado) > 0) {

                    foreach ($listado as $key => $value) {
                        $rdo = $ManagerArchivosMensajeConsultaExpress->cloneArchivoMensaje($value["idarchivosMensajeConsultaExpress"], $idmensajeNew);
                        if (!$rdo) {
                            return false;
                        }
                    }

                    return $idmensajeNew;
                } else {

                    return $idmensajeNew;
                }
            }
        } else {

            return false;
        }
    }

    /**
     * Método que retorna el primer mensaje
     * @param type $idconsultaExpress
     * @return type
     */
    public function getPrimerMensaje($idconsultaExpress) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("consultaExpress_idconsultaExpress = {$idconsultaExpress}");

        $query->setOrderBy("fecha DESC");

        $query->setLimit("0,1");

        return $this->db->GetRow($query->getSql());
    }

    /*     * metodo que retorna el listado de los mensajes entre paciente y medicos en una consulta express
     * 
     */

    public function getListadoMensajes($idconsultaExpress) {

        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table t 
                            INNER JOIN consultaexpress ce ON (t.consultaExpress_idconsultaExpress = ce.idconsultaExpress)
                    ");

        $query->setWhere("t.consultaExpress_idconsultaExpress={$idconsultaExpress}");

        $query->setOrderBy("t.fecha ASC");

        $rdo = $this->getList($query);

        if (count($rdo) > 0) {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
            foreach ($rdo as $key => $value) {
                //Formateo la fecha para ver si cambia de fecha o no
                if ($key == 0) {
                    $explode_fecha = explode(" ", $value["fecha"]);
                    $fecha = $explode_fecha[0]; //Saco las horas a la fecha
                    $rdo[$key]["fecha_divisoria"] = fechaToString($value["fecha"]);
                } else {
                    //Obtengo la fecha del mensaje, y me fijo.. 
                    $explode_fecha_comparacion = explode(" ", $value["fecha"]);
                    $fecha_comparacion = $explode_fecha_comparacion[0];
                    if ((string) $fecha != (string) $fecha_comparacion) {
                        //Si la fecha es distinta a la fecha del mensaje actual, tengo que setear la línea divisoria
                        $fecha = $fecha_comparacion;
                        $rdo[$key]["fecha_divisoria"] = fechaToString($value["fecha"]);
                    }
                }

                //Me fijo si el mensaje tiene un audio
                if (is_file(path_entity_files("audios/{$idconsultaExpress}/{$value[$this->id]}.wav"))) {
                    $rdo[$key]["mensaje_audio"] = URL_ROOT . "xframework/files/entities/audios/{$idconsultaExpress}/{$value[$this->id]}.wav";
                }
                if (is_file(path_entity_files("audios/{$idconsultaExpress}/{$value[$this->id]}.mp3"))) {
                    $rdo[$key]["mensaje_audio"] = URL_ROOT . "xframework/files/entities/audios/{$idconsultaExpress}/{$value[$this->id]}.mp3";
                }

                //Si al mensaje lo envío el médico, le inicializo la imagen de perfil del médico
                if (CONTROLLER != "medico" && $value["medico_idmedico"] != "") {
                    $rdo[$key]["imagen_medico"] = $ManagerMedico->getImagenMedico($value["medico_idmedico"]);
                } elseif ($value["paciente_idpaciente"] != "") {
                    //Si los mensajes se listan desde el lado del médico, muestre la foto del paciente
                    $rdo[$key]["imagen_paciente"] = $ManagerPaciente->getImagenPaciente($value["paciente_idpaciente"]);
                }

                //Tengo que formatear la fecha de inicio.
                if ($value["fecha"] != "") {
                    $rdo[$key]["fecha_format"] = fechaToString($value["fecha"], 1);
                }

                $cantidad_archivos = $ManagerArchivosMensajeConsultaExpress->getCantidadArchivosMensaje($value[$this->id]);
                if ($cantidad_archivos && (int) $cantidad_archivos["cantidad"] > 0) {
                    $rdo[$key]["cantidad_archivos_mensajes"] = (int) $cantidad_archivos["cantidad"];
                }
            }
        }
        return $rdo;
    }

    /*     * metodo que devuelve la cantidad de mensajes sin leer de la consulta Express
     * 
     * @param type $idconsultaExpress consulta a la que pertenece el mensaje
     * @param type $receptor "m" o "p" segun a quien se haya enviado el mensaje
     * @return type
     */

    public function getCantidadMensajesNoLeidos($idconsultaExpress, $receptor) {

        $query = new AbstractSql();
        $query->setSelect("count(*) as qty");
        $query->setFrom("$this->table t");
        $query->setWhere("consultaExpress_idconsultaExpress=$idconsultaExpress and emisor<>'$receptor' and leido=0");

        $rdo = $this->db->getRow($query->getSql());

        return $rdo;
    }

    /**
     * Setea el estado de los mensajes leídos
     * @param type $idconsultaExpress
     * @return boolean
     */
    public function setMensajesLeidosAll($idconsultaExpress) {

        //verificamos que el mensaje pertenezca a la persona indicada
        $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

        $consulta = $ManagerConsultaExpress->get($idconsultaExpress);
        if (CONTROLLER == "medico") {
            $emisor = "p";

            $condicion = " medico_idmedico = {$consulta["medico_idmedico"]}";
            //guardamos el estado previo para saber si ya habia sido visualizada y no descontar por JS el contador
            $leido_anteriormente = $consulta["leido_medico"];
            //marcamos la notificacion leida

            $res = $ManagerConsultaExpress->setNotificacionesLeidasMedico(["idconsultaExpress" => $idconsultaExpress]);
        } else {
            $emisor = "m";

            $condicion = " paciente_idpaciente = {$consulta["paciente_idpaciente"]}";
            //guardamos el estado previo para saber si ya habia sido visualizada y no descontar por JS el contador
            $leido_anteriormente = $consulta["leido_paciente"];
            //marcamos la notificacion leida
            $res = $ManagerConsultaExpress->setNotificacionesLeidasPaciente(["idconsultaExpress" => $idconsultaExpress]);
        }

        //marcamos los mensajes leidos
        $update = "UPDATE $this->table m 
                            INNER JOIN consultaexpress ce ON (ce.idconsultaExpress = m.consultaExpress_idconsultaExpress) SET m.leido = 1 
                            WHERE m.emisor='{$emisor}' AND ce.idconsultaExpress = {$idconsultaExpress}
                                AND ({$condicion})";

        $rdo = $this->db->Execute($update);



        if ($rdo) {
            $this->setMsg(["result" => true, "leido_anteriormente" => $leido_anteriormente]);
            return true;
        } else {
            $this->setMsg(["result" => false]);
            return false;
        }
    }

    /*     * Metodo que envia un mensaje via email a paciente/medico cuando se inserta una respuesta a una consulta express
     * 
     * @param type $request
     */

    public function enviarMailMensajeCE($request) {

        $consulta = $this->getManager("ManagerConsultaExpress")->get($request["consultaExpress_idconsultaExpress"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        $paciente["imagen"] = $ManagerPaciente->getImagenPaciente($consulta["paciente_idpaciente"]);
        $medico = $ManagerMedico->get($consulta["medico_idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($consulta["medico_idmedico"]);



        //Si el email es vació puede ser que sea un miembro del grupo familiar
        if ($paciente["email"] == "") {
            $paciente_titular = $ManagerPaciente->getPacienteTitular($consulta["paciente_idpaciente"]);
        }

        if ($paciente["email"] == "" && $paciente_titular["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del paciente ", "result" => false]);
            return false;
        }

        if ($medico["email"] == "") {
            $this->setMsg(["msg" => "Error al recuperar email del medico ", "result" => false]);
            return false;
        }

        $motivo = $this->getManager("ManagerMotivoConsultaExpress")->get($consulta["motivoConsultaExpress_idmotivoConsultaExpress"]);


        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();



        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("consulta", $consulta);
        $smarty->assign("motivo", $motivo["motivoConsultaExpress"]);
        $smarty->assign("mensaje", $request["mensaje"]);
        $smarty->assign("audio_mail", $request["audio_mail"]);

        $ManagerArchivosMensajeConsultaExpress = $this->getManager("ManagerArchivosMensajeConsultaExpress");
        //Obtengo todas las imágenes del perfil de salud estudio
        $list_imagenes = $ManagerArchivosMensajeConsultaExpress->getListImages($request["idmensajeConsultaExpress"]);
        $smarty->assign("imagenes", $list_imagenes);



        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_respuesta_consultaexpress.tpl"));

        //ojo solo arnet local
        $mEmail->setPort("587");




        if (CONTROLLER == "medico") {
            $mEmail->setSubject(sprintf("WorknCare | {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} a répondu à votre demande de Conseil Nº %s", $consulta["numeroConsultaExpress"]));
            $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        } else {
            $mEmail->setSubject(sprintf("WorknCare | Conseil Nº %s le patient vous a répondu", $consulta["numeroConsultaExpress"]));
            $email = $medico["email"];
        }

        $mEmail->addTo($email);


        //NO ADJUNTAR FOTOS POR  MAIL
        /* if ($list_imagenes && count($list_imagenes) > 0) {

          foreach ($list_imagenes as $imagen) {

          if (file_exists(path_entity_files("mensajes_ce/" . $imagen["idarchivosMensajeConsultaExpress"] . "/" . $imagen["nombre"] . ".jpg"))) {
          $mEmail->AddAttachment(path_entity_files("mensajes_ce/" . $imagen["idarchivosMensajeConsultaExpress"] . "/" . $imagen["nombre"] . ".jpg"), $imagen["nombre"] . ".jpg");
          }
          }
          }
         */

        if ($mEmail->send()) {
            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

    /**
     * Método que se utiliza para enviar al paciente o medico SMS cuando se agrega un mensaje
     * @return boolean
     */
    public function enviarSMSMensajeConsultaExpress($idconsultaExpress) {

        $consulta = $this->getManager("ManagerConsultaExpress")->get($idconsultaExpress);
        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($consulta["medico_idmedico"]);

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($consulta["paciente_idpaciente"]);
        //si ingresa el medico le enviamos un mail le enviamos un sms al paciente
        if (CONTROLLER == "medico") {

            $destinatario = "P";


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
            if ($medico["sexo"] == 1) {
                $sexo = "Mr";
            } else {
                $sexo = "Mme";
            }
            $cuerpo = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} vous a répondu: \n" .
                    URL_ROOT . "patient/consultation-express/en-cours-detail-patient-{$consulta["idconsultaExpress"]}.html";
        }
        //si ingresa el paciente le enviamos un sms al medico
        if (CONTROLLER == "paciente_p") {

            $destinatario = "M";


            if ($medico["numeroCelular"] != "" && $medico["celularValido"]) {
                $numero = $medico["numeroCelular"];
                $cuerpo = "{$paciente["nombre"]} {$paciente["apellido"]} a donné un avis pour la Conseil Nº{$consulta["numeroConsultaExpress"]}: \n" .
                        URL_ROOT . "professionnel/consultation-express/en-cours-detail-professionnel-{$consulta["idconsultaExpress"]}.html";
            } else {
                return false;
            }
        }


        /**
         * Inserción del SMS en la lista de envio
         */
        $ManagerLogSMS = $this->getManager("ManagerLogSMS");
        $sms = $ManagerLogSMS->insert([
            "dirigido" => $destinatario,
            "paciente_idpaciente" => $paciente["idpaciente"],
            "medico_idmedico" => $medico["idmedico"],
            "contexto" => "Mensaje CE",
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

}
