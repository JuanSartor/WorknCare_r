<?php

/**
 * 	Manager del perfil de salud de estudios e imágenes correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludEstudiosImagen extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludestudiosimagen", "idperfilSaludEstudiosImagen");

        $this->default_paginate = "perfil_salud_estudios_imagen_list";
        $this->setImgContainer("estudios_imagenes");

        $this->setImgContainerMultiple("images_estudios_imagenes");
        $this->addImgType("jpg");
        $this->addImgType("png");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    public function process($request) {

        $rdo = parent::process($request);

        if (!$rdo) {
            $this->setMsg(["result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            $this->setMsg(["result" => true, "msg" => "Registro actualizado con éxito", "id" => $rdo]);
            return $rdo;
        }
    }

    /**
     * Método que procesa el upload múltiple de las imágenes correspondientes a los estudios de salud Estudios
     * @param type $request
     * @return boolean
     */
    public function processAllFiles($request) {

        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];

        $flag_estudio_true = false;
        for ($i = 0; $i < 20; $i++) {
            //Por cada cantidad tiene que haber una imagen insertada en la carpeta temporal "images_estudios_imagenes"
            //Me fijo si existe el path
            if (isset($_SESSION[$hash][$i])) {
                $ext = $datos_session[$i]["ext"];
                $dir = path_root("xframework/files/temp/images_estudios_imagenes/{$hash}/");
                $path = path_root("xframework/files/temp/images_estudios_imagenes/{$hash}/{$i}.{$ext}");

                //Si existe el path, se inserta la imagen
                if (is_file($path)) {
                    $request["nombre_archivo"] = $datos_session[$i]["filename"];
                    $request["ext"] = $ext;
                    //guardamos en Session los datos de cada imagen para el insert multiple
                    $_SESSION[$hash] = $datos_session[$i];

                    //$this->print_r($_SESSION[$request["hash"]]);
                    $rdo = parent::insert($request);

                    //copiamos el archivo a su ubicacion final
                    $path_entity_file = path_entity_files("{$this->getImgContainer()}/{$rdo}/{$request["nombre_archivo"]}.{$ext}");
                    copy($path, $path_entity_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($path_entity_file) || !is_file($path_entity_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }

                    if (!$rdo) {
                        $this->setMsg(["msg" => "Error. No se pudo insertar la imagen [" . $request["nombre_archivo"] . "]", "result" => false]);
                        return false;
                    } else {
                        $flag_estudio_true = true;
                    }
                    //restauramos los datos de session con todas las imagenes
                    $_SESSION[$hash] = $datos_session;
                    //Elimino el archivo
                    unlink($path);
                }
            }
        }

        if ($flag_estudio_true) {
            $this->setMsg(["msg" => "Las imágenes fueron subidas y procesadas correctamente", "result" => true]);
            rmdir($dir);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No se pudo subir ninguna imagen, verifique sus formatos y tamaños", "result" => false]);
            return false;
        }
    }

    /**
     * Devolución del listado paginado de los perfiles de salud estudios
     * Se le adjunta además la ubicación de las imágenes para fácil acceso en las View
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListImages($idperfilSaludEstudios) {

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.perfilSaludEstudios_idperfilSaludEstudios = $idperfilSaludEstudios");

        $listado = $this->getList($query);

        if ($listado) {
            //Recorro cada listado y le pongo el path
            foreach ($listado as $key => $value) {
                //fix archivos con espacios en filename 
                $value["nombre_archivo"] = str_replace(" ", "%20", $value["nombre_archivo"]);
                $listado[$key]["path_images_perfil"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "_perfil." . $value["ext"];
                $listado[$key]["path_images_usuario"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "_usuario." . $value["ext"];
                $listado[$key]["path_images_list"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "_list." . $value["ext"];
                $listado[$key]["path_images_gallery"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "." . $value["ext"];
                //si es PDF reemplazamos la miniatura por un icono
                if ($value["ext"] == "pdf") {
                    $listado[$key]["path_images"] = URL_ROOT . "xframework/app/themes/dp02/imgs/ico_pdf.png";
                } else {
                    $listado[$key]["path_images"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "." . $value["ext"];
                }
                $listado[$key]["url"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "." . $value["ext"];
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que tiene un listado de imágenes 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListImagesConsulta($request) {


        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : $request["paciente_idpaciente"];

        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado) {
            //Recorro cada listado y le pongo el path
            foreach ($listado as $key => $value) {
                //fix archivos con espacios en filename
                $value["nombre_archivo"] = str_replace(" ", "%20", $value["nombre_archivo"]);
                $listado[$key]["path_images_list"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "_list." . $value["ext"];
                $listado[$key]["path_images"] = URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $value[$this->id] . "/" . $value["nombre_archivo"] . "." . $value["ext"];
            }
            return $listado;
        } else {
            return false;
        }
    }

    public function get($id, $query = NULL, $alias = NULL) {
        $rdo = parent::get($id, $query, $alias);
        if ($rdo) {
            //fix archivos con espacios en filename
            $rdo["nombre_archivo"] = str_replace(" ", "%20", $rdo["nombre_archivo"]);
            $rdo["images"] = array(
                "list" => URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . "_list." . $rdo["ext"],
                "gallery" => URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . "." . $rdo["ext"],
                "perfil" => URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . "_perfil." . $rdo["ext"],
                "usuario" => URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . "_usuario." . $rdo["ext"],
                "image" => URL_ROOT . "xframework/files/entities/estudios_imagenes/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . "." . $rdo["ext"],
            );
            return $rdo;
        } else {
            return false;
        }
    }

    /**
     * Método que elimina el directorio temporal de Upload múltiple asociado al id del paciente
     * @param type $id : Id del paciente
     * @return boolean
     */
    public function cancelarUploadMultiple($id) {


        $dir = path_files("temp/{$this->imgContainerMultiple}/{$id}");

        if (is_dir($dir)) {

            $class_dir = new Dir();
            $class_dir->deleteDir($dir);

            rmdir($dir);

            $this->setMsg(["msg" => "Se ha cancelado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No hay imágenes subidas para cancelar", "result" => false]);
            return false;
        }
    }

    /**
     * Delete múltiple de las imágenes
     * @param type $ids
     * @return boolean
     */
    public function deleteMultiple($ids) {
        $listado_ids = explode(",", $ids);
        if ($listado_ids && count($listado_ids) > 0) {
            $eliminados = 0;
            $no_eliminados = 0;
            foreach ($listado_ids as $key => $id) {
                if ($id != "") {
                    $rdo = parent::delete($id, true);
                    if ($rdo) {
                        $eliminados++;
                    } else {
                        $no_eliminados++;
                    }
                }
            }

            if ($no_eliminados > 0) {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo eliminar los archivos"]);
            } else {
                $this->setMsg(["result" => true, "msg" => "Se eliminaron todos los archivos con éxito"]);
            }
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No hay imágenes seleccionadas"]);
            return false;
        }
    }

}

//END_class
?>