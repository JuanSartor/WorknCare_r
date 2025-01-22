<?php

/**
 * ManagerMensajeVideoConsulta administra los mensajes enviados entre medico y pacientes en una videoconsulta
 *
 * @author lucas
 */
class ManagerMensajeVideoConsulta extends AbstractManager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "mensajevideoconsulta", "idmensajeVideoConsulta");
    }

    /*     * Metodo que inserta un registro cuando se envia un mensaje entre medico y paciente en una videoconsulta**
     * 
     */

    public function insert($request) {

        $request["videoconsulta_idvideoconsulta"] = $request["idvideoconsulta"];

        $videoconsulta = $this->getManager("ManagerVideoConsulta")->get($request["idvideoconsulta"]);

        $request["estadoVideoConsulta_idestadoVideoConsulta"] = $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"];

        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "1" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "2" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "6" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] != "7") {

            $this->setMsg(["msg" => "Error. La consulta no se encuentra en curso", "result" => false]);

            return false;
        }




        //verificamos que la consulta pertenezca al paciente
        if (CONTROLLER == "paciente_p") {
            $idpaciente_session = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];
            $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
            $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($videoconsulta["paciente_idpaciente"], $idpaciente_session);

            //verificamos que la consulta sea del titular o algun miembro

            if ($videoconsulta["paciente_idpaciente"] != $paciente["idpaciente"] && $videoconsulta["paciente_idpaciente"] != $idpaciente_session && $familiar["pacienteGrupo"] != $videoconsulta["paciente_idpaciente"]) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                return false;
            }
        }

        //verificamos que la consulta pertenezca al medico
        if (CONTROLLER == "medico") {

            $idmedico = (int) $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
            if ($videoconsulta["medico_idmedico"] != $idmedico) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo recuperar la consulta a actualizar"]);
                return false;
            }
        }

        //agregar toda la logica necesaria
        if ($request["mensaje"] == "") {
            if ($request["hash"] != "") {
                $request["mensaje"] = "Envoi de fichiers";
            } else {
                $this->setMsg(["msg" => "Ingrese el texto del mensaje", "result" => false]);
                return false;
            }
        }



        $request["fecha"] = date("Y-m-d H:i:s");


        //seteamos quien es el emisor y el flag leido en 0 de la consulta express para que le aparezca la notificacion al receptor
        if (CONTROLLER == "medico") {

            $request["emisor"] = "m";
        }
        if (CONTROLLER == "paciente_p" || CONTROLLER == "paciente") {
            $request["paciente_idpaciente"] = $videoconsulta["paciente_idpaciente"];
            $request["emisor"] = "p";
        }
        $request["mensaje"] = htmlspecialchars($request["mensaje"], ENT_NOQUOTES);

        $rdo = parent::insert($request);
        if ($request["hash"] != "" && $request["cantidad_image"] > 0) {
            $ManagerArchivosMensajeVideoConsulta = $this->getManager("ManagerArchivosMensajeVideoConsulta");
            $request["idmensajeVideoConsulta"] = $rdo;

            $process_images = $ManagerArchivosMensajeVideoConsulta->processAllFiles($request);
            if (!$process_images) {
                $this->setMsg($ManagerArchivosMensajeVideoConsulta->getMsg());
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
            //obtengo las imagenes para mostrar en el chat
            $imagenes = $ManagerArchivosMensajeVideoConsulta->getListImages($rdo);
        }
        if ($request["repuesta_desde_consulta"] == "1") {
            $enviar_mail = $this->enviarMailMensajeVC($request);
            if (!$enviar_mail) {
                $this->setMsg(["msg" => "Error. No se ha podido almacenar el mensaje en el sistema.", "result" => false]);
                $this->db->FailTrans();
                $this->db->CompleteTrans();
                return false;
            }
        }
        if ($rdo) {
            $this->setMsg(["msg" => "Su mensaje se ha enviado con éxito.", "result" => true, "imagenes" => $imagenes]);

            $this->db->CompleteTrans();
            return $rdo;
        } else {
            $this->setMsg(["msg" => "Error. No se ha podido almacenar el mensaje en el sistema.", "result" => false]);
            $this->db->FailTrans();
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

    /*     * metodo que retorna el listado de los mensajes entre paciente y medicos en una video consulta
     * 
     */

    public function getListadoMensajes($idvideoconsulta) {

        $videoconsulta = $this->getManager("ManagerVideoConsulta")->get($idvideoconsulta);

        //se agrega un mensaje que corresponde al ingreso a la sala del medico cuando se vuelve a iniciar la sala en las consultas pendientes de finalizacion
        /*         * Mensaje:Se ha intentado establecer una videoconsulta
         * cuando la consulta esta en estado pendiente de confirmacion y el medico volvio a ingresar a la sala para llamar al paciente
         * o cuando se obtiene el listado de finalizadas del medico (porque pasaron 6 horas de su publicacion y se acredita el dinero)
         * 
         */

        if (($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 8 || (CONROLLER == "medico" && $videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 4))) {

            $query1 = new AbstractSql();
            $query1->setSelect("t.*");
            $query1->setFrom("$this->table t 
                            INNER JOIN videoconsulta vc ON (t.videoconsulta_idvideoconsulta = vc.idvideoconsulta)
                    ");
            $query1->setWhere("t.videoconsulta_idvideoconsulta={$idvideoconsulta}");
            //añadimos los intentos de llamada como un mensaje
            $query2 = new AbstractSql();
            $query2->setSelect("r.idregistro_inicio_sala as idmensajeVideoConsulta,
                                r.inicio_sala as fecha,
                                'Se ha intentado establecer una videoconsulta' as mensaje,
                                'dp' as emisor,
                                r.videoconsulta_idvideoconsulta
                                ");
            $query2->setFrom("registro_inicio_sala r 
                            INNER JOIN videoconsulta vc ON (r.videoconsulta_idvideoconsulta = vc.idvideoconsulta)
                    ");
            $query2->setWhere("r.videoconsulta_idvideoconsulta={$idvideoconsulta}");

            $query = new AbstractSql();
            $query->setSelect("T.*");
            $query->setFrom("((" . $query1->getSql() . ") UNION (" . $query2->getSql() . ")) as T");
            $query->setOrderBy("T.fecha ASC");

            $rdo = $this->getList($query);
        } else {
            $query = new AbstractSql();

            $query->setSelect("t.*");

            $query->setFrom("$this->table t 
                            INNER JOIN videoconsulta vc ON (t.videoconsulta_idvideoconsulta = vc.idvideoconsulta)
                    ");

            $query->setWhere("t.videoconsulta_idvideoconsulta={$idvideoconsulta}");

            $query->setOrderBy("t.fecha ASC");

            $rdo = $this->getList($query);
        }


        if (count($rdo) > 0) {
            $ManagerMedico = $this->getManager("ManagerMedico");
            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerArchivosMensajeVideoConsulta = $this->getManager("ManagerArchivosMensajeVideoConsulta");
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

                if (is_file(path_entity_files("audios/{$idvideoconsulta}/{$value[$this->id]}.ogg"))) {
                    $rdo[$key]["mensaje_audio"] = URL_ROOT . "xframework/files/entities/audios/{$idvideoconsulta}/{$value[$this->id]}.ogg";
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

                $cantidad_archivos = $ManagerArchivosMensajeVideoConsulta->getCantidadArchivosMensaje($value[$this->id]);
                if ($cantidad_archivos && (int) $cantidad_archivos["cantidad"] > 0) {
                    $rdo[$key]["cantidad_archivos_mensajes"] = (int) $cantidad_archivos["cantidad"];
                }
            }
        }

        return $rdo;
    }

    /**
     * Método que retorna el primer mensaje
     * @param type $idvideoconsulta
     * @return type
     */
    public function getPrimerMensaje($idvideoconsulta) {
        $query = new AbstractSql();

        $query->setSelect("*");

        $query->setFrom("$this->table");

        $query->setWhere("videoconsulta_idvideoconsulta = {$idvideoconsulta}");

        $query->setOrderBy("fecha DESC");

        $query->setLimit("0,1");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Método utilizado para clonar los mensajes desde otro mensaje
     * @param type $request
     */
    public function cloneMensaje($idmensajeToClone, $idvideoconsulta) {
        $mensaje = parent::get($idmensajeToClone);

        if ($mensaje) {
            $insert = $mensaje;

            unset($insert[$this->id]);
            $insert["videoconsulta_idvideoconsulta"] = $idvideoconsulta;
            $idmensajeNew = parent::insert($insert);

            if ($idmensajeNew) {
                /**
                 * Copio las imagenes
                 */
                $ManagerArchivosMensajeVideoConsulta = $this->getManager("ManagerArchivosMensajeVideoConsulta");
                $listado = $ManagerArchivosMensajeVideoConsulta->getListImages($mensaje[$this->id]);

                if ($listado && count($listado) > 0) {
                    foreach ($listado as $key => $value) {
                        $rdo = $ManagerArchivosMensajeVideoConsulta->cloneArchivoMensaje($value["idarchivosMensajeVideoConsulta"], $idmensajeNew);
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

    /*     * Metodo que retorna los mensajes de una VC con imagenes, formateados para su uso en el chat de VC
     * 
     * @param type $idvideoconsulta
     * @return array
     */

    public function getListadoMensajesChatVC($idvideoconsulta) {
        $listado = $this->getListadoMensajes($idvideoconsulta);
        $listadoMensajesVC = [];
        foreach ($listado as $mensaje) {
            if ($mensaje["cantidad_archivos_mensajes"] != "") {

                if ($mensaje["mensaje"] != "Envoi de fichiers") {
                    $mensaje["is_imagen"] = 0;
                    array_push($listadoMensajesVC, $mensaje);
                }
                //agregamos todas las fotos como una mensaje
                $listado_imagenes = $this->getManager("ManagerArchivosMensajeVideoConsulta")->getListImages($mensaje["idmensajeVideoConsulta"]);
                foreach ($listado_imagenes as $imagen) {
                    $mensaje["is_imagen"] = 1;
                    $mensaje["imagen"] = $imagen;
                    array_push($listadoMensajesVC, $mensaje);
                }
            } else {
                $mensaje["is_imagen"] = 0;
                array_push($listadoMensajesVC, $mensaje);
            }
        }

        return $listadoMensajesVC;
    }

    /**
     * Metodo que envia un mensaje via email a paciente/medico cuando se inserta una respuesta a una videoconsulta abierta
     * 
     * @param type $request
     */
    public function enviarMailMensajeVC($request) {

        $consulta = $this->getManager("ManagerVideoConsulta")->get($request["videoconsulta_idvideoconsulta"]);

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

        $motivo = $this->getManager("ManagerMotivoVideoConsulta")->get($consulta["motivoVideoConsulta_idmotivoVideoConsulta"]);


        //envio de la invitacion por mail
        $smarty = SmartySingleton::getInstance();



        $smarty->assign("paciente", $paciente);
        $smarty->assign("medico", $medico);
        $smarty->assign("consulta", $consulta);
        $smarty->assign("motivo", $motivo["motivoVideoConsulta"]);
        $smarty->assign("mensaje", $request["mensaje"]);


        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);
        $mEmail->setBody($smarty->Fetch("email/mensaje_respuesta_videoconsulta.tpl"));

        //ojo solo arnet local
        $mEmail->setPort("587");




        if (CONTROLLER == "medico") {
            $mEmail->setSubject(sprintf("WorknCare | {$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} a répondu à votre message de Vidéo Consultation Nº%s", $consulta["numeroVideoConsulta"]));
            $email = $paciente["email"] == "" ? $paciente_titular["email"] : $paciente["email"];
        } else {
            $mEmail->setSubject(sprintf("WorknCare | Vidéo Consultation Nº%s le patient vous a répondu", $consulta["numeroVideoConsulta"]));
            $email = $medico["email"];
        }

        $mEmail->addTo($email);

        if ($mEmail->send()) {

            //notify
            $client = new XSocketClient();



            if (CONTROLLER == "medico") {
                $notify["title"] = "{$medico["tituloprofesional"]} {$medico["nombre"]} {$medico["apellido"]} - Vidéo Consultation";
                $notify["paciente_idpaciente"] = $consulta["paciente_idpaciente"];
                $notify["text"] = "A répondu à votre message";
            } else {
                $notify["title"] = "{$paciente["nombre"]} {$paciente["apellido"]} - Vidéo Consultation";
                $notify["medico_idmedico"] = $consulta["medico_idmedico"];
                $notify["text"] = "A répondu à votre message";
            }
            $notify["id"] = $consulta["idvideoconsulta"];
            $notify["type"] = "recordatorio-proxima-vc";
            $notify["style"] = "video-consulta";
            $client->emit('notify_php', $notify);


            $this->setMsg(["msg" => "Mensaje enviado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No se ha podido enviar el mensaje. Inténtelo más tarde", "result" => false]);
            return false;
        }
    }

}
