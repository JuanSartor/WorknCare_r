<?php

/**
 * 	Manager del perfil de salud de estudios e imágenes correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerMedicoCompartirEstudio extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "medicocompartirestudio", "idmedicoCompartirEstudio");
    }

    public function insert($request) {

        $request["fechaCompartido"] = date("Y-m-d H:i:s");


        return parent::insert($request);
    }

    public function process($request) {

        $rdo = parent::process($request);

        if (!$rdo) {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            $this->setMsg(["result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);

            //Tengo que crear la notificacion para compartir estudio si es un insert
            if ($request[$this->id] == "") {
                $ManagerNotificacion = $this->getManager("ManagerNotificacion");
                $request[$this->id] = $rdo;
                $rdo_creacion_notificacion = $ManagerNotificacion->processNotificacionCompartirEstudio($request);
            }


            return $rdo;
        }
    }

    /**
     * Método que envía la consulta realizada por un médico a otro
     * @param array $request
     * @return boolean
     */
    public function sendConsulta($request) {
        if ($request["ids"] == "" || $request["medico_idmedico_recibe"] == "") {
            $this->setMsg(["result" => false, "msg" => "Error, faltan datos obligatorios, verifique las imágenes o el médico seleccionado"]);
            return false;
        }

        $request["medico_idmedico"] = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($request["medico_idmedico"]);
        $medico_recibe = $ManagerMedico->get($request["medico_idmedico_recibe"]);

        //Comienzo a enviar el mail
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");


        $titulo = $medico["titulo_profesional"]["titulo_profesional"];
        $subject .= $titulo . " " . $medico["nombre"] . " " . $medico["apellido"] . " vous a envoyé une consultation";


        $mEmail->setSubject($subject);

        //Recorro todas las imágenes
        if ($request["ids"] != "") {
            $list_ids = explode(",", $request["ids"]);
            if (count($list_ids) > 0) {
                $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");

                foreach ($list_ids as $key => $id) {
                    if ((int) $id > 0) {
                        //Obtengo todas las imágenes del perfil de salud estudio
                        $list_estudio_imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages((int) $id);
                        if ($list_estudio_imagenes && count($list_estudio_imagenes) > 0) {
                            foreach ($list_estudio_imagenes as $key => $imagen_estudio) {
                                if (file_exists(path_entity_files("estudios_imagenes/" . $imagen_estudio["idperfilSaludEstudiosImagen"] . "/" . $imagen_estudio["nombre_archivo"] . ".jpg"))) {
                                    $mEmail->AddAttachment(path_entity_files("estudios_imagenes/" . $imagen_estudio["idperfilSaludEstudiosImagen"] . "/" . $imagen_estudio["nombre_archivo"] . ".jpg"), $imagen_estudio["nombre_archivo"] . "." . $imagen_estudio["ext"]);
                                }
                            }
                        }
                    }
                }
            }
        }

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("medico", $medico);
        $smarty->assign("medico_recibe", $medico_recibe);
        $smarty->assign("request", $request);
        $smarty->assign("sistema", NOMBRE_SISTEMA);

        $mEmail->setBody($smarty->Fetch("email/consulta_medico.tpl"));

        $mEmail->addTo($medico_recibe["email"]);

        if ($mEmail->send() || true) {
            $rdo = $this->process($request);

            $this->setMsg(["result" => true, "msg" => "Se ha enviado un mail al médico con la consulta."]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar el mail"]);
            return false;
        }
    }

    /**
     * Método que retorna un listado con la información correspondiente a los estudios de los médicos para compartir
     * @return string|boolean
     */
    public function getNotificacionesMedico() {

        $query = new AbstractSql();

        $query->setSelect("
                            t.*,
                            uw.nombre,
                            uw.apellido
                        ");

        $query->setFrom("
                        $this->table t
                            INNER JOIN medico m ON (t.medico_idmedico = m.idmedico)
                            INNER JOIN usuarioweb uw ON (m.usuarioweb_idusuarioweb = uw.idusuarioweb)
                    ");

        $query->setWhere("t.medico_idmedico_recibe = " . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

//          $query->addAnd("t.visto_medico = 0");

        $listado = $this->getList($query);

        if ($listado && count($listado) > 0) {

            $calendar = new Calendar();

            foreach ($listado as $key => $value) {


                $date_explode = explode(" ", $value["fechaCompartido"]);
                if (count($date_explode) == 2) {
                    list($y, $m, $d) = preg_split("[-]", $date_explode[0]);
                    $mes = $calendar->getMonthsShort((int) $m);
                    $listado[$key]["fechaCompartido_format"] = "$d $mes $y " . $date_explode[1];
                }

                /**
                 * Busco las imágenes
                 */
                if ($value["ids"] != "") {
                    $list_ids = explode(",", $value["ids"]);
                    if (count($list_ids) > 0) {

                        $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");

                        $attach = array();

                        foreach ($list_ids as $key => $id) {
                            if ((int) $id > 0) {

                                $estudio = $ManagerPerfilSaludEstudios->get((int) $id);

                                $filename = path_entity_files("estudios_imagenes/$id/" . $estudio["nombre_archivo"] . "." . $estudio["ext"]);

                                if (file_exists($filename)) {

                                    $path_file = array(
                                        "path_file_list" => $estudio["images"]["list"],
                                        "path_file" => $estudio["images"]["image"],
                                        "name_file" => $estudio["nombre_archivo"] . "." . $estudio["ext"]
                                    );
                                    $attach[] = $path_file;
                                }
                            }
                        }


                        $listado[$key]["file"] = count($attach) > 0 ? $attach : false;
                    }
                }
            }

            return $listado;
        } else {
            return false;
        }
    }

}

//END_class
?>