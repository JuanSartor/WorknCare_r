<?php

/**
 * ManagerArchivosMensajeVideoConsulta administra los archivos contenidos en los mensajes enviados en una videoconsulta
 *
 * @author lucas
 */
class ManagerArchivosMensajeVideoConsulta extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "archivosmensajevideoconsulta", "idarchivosMensajeVideoConsulta");

        $this->setImgContainer("mensajes_vc");

        $this->setImgContainerMultiple("images_mensajes_vc");
        $this->addImgType("jpg");
        $this->addImgType("png");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    /**
     * Método que procesa el upload múltiple de los archivos correspondientes a las VC
     * @param type $request
     * @return boolean
     */
    public function processAllFiles($request) {

        if (CONTROLLER == "medico") {
            $id = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
        } else {
            $id = $request["paciente_idpaciente"];
        }

        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];

        $request["mensajeVideoConsulta_idmensajeVideoConsulta"] = $request["idmensajeVideoConsulta"];
        //Flag para verificar si ocurre algún error.
        $flag_estudio_true = false;
        //Variable para ver si hay imágenes
        $exist_images = false;
        for ($i = 0; $i < 20; $i++) {
            //Por cada cantidad tiene que haber una imagen insertada en la carpeta temporal "images_estudios_imagenes"
            //Me fijo si existe el path
            if (isset($_SESSION[$hash][$i])) {
                $exist_images = true;
                $ext = $datos_session[$i]["ext"];

                $dir = path_root("xframework/files/temp/images_mensajes_vc/{$hash}/");
                $path = path_root("xframework/files/temp/images_mensajes_vc/{$hash}/{$i}.{$ext}");


                //Si existe el path, se inserta la imagen
                if (is_file($path)) {

                    $request["nombre"] = "{$datos_session[$i]["filename"]}";
                    $request["ext"] = $ext;
                    //guardamos en Session los datos de cada imagen para el insert multiple
                    $_SESSION[$hash] = $datos_session[$i];

                    $rdo = parent::insert($request);
                    //copiamos el archivo a su ubicacion final
                    $path_entity_file = path_entity_files("{$this->getImgContainer()}/{$rdo}/{$request["nombre"]}.{$ext}");
                    copy($path, $path_entity_file);
                    //comprobamos que se hayan movido
                    if (!file_exists($path_entity_file) || !is_file($path_entity_file)) {
                        $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                        return false;
                    }
                    if (!$rdo) {
                        $this->setMsg(["msg" => "Error. No se pudo insertar la imagen [[{$request["nombre_archivo"] }]]", "result" => false]);
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

        if ($flag_estudio_true && $exist_images) {
            $this->setMsg(["msg" => "Las imágenes fueron subidas y procesadas correctamente", "result" => true]);
            rmdir($dir);
            return true;
        } else if ($flag_estudio_true == false && $exist_images) {
            //Se produjo un error y existen imágenes
            $this->setMsg(["msg" => "Error. No se pudo subir ninguna imagen, verifique sus formatos y tamaños", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No hay imágenes para insertar", "result" => false]);
            return true;
        }
    }

    /**
     * Me´todo utlizado para clonar los archivos de los mensajes
     * @param type $id_archivo_mensaje_old
     * @param type $idmensajeVideoConsulta
     * @return boolean
     */
    public function cloneArchivoMensaje($id_archivo_mensaje_old, $idmensajeVideoConsulta) {

        //busco el archivo del mensaje anterior
        $archivoMensaje = parent::get($id_archivo_mensaje_old);

        $insert_archivo_mensaje = $archivoMensaje;


        //Archivo a clonar
        $path_to_clone = path_entity_files("{$this->getImgContainer()}/{$archivoMensaje[$this->id]}/{$archivoMensaje["nombre"]}.{$archivoMensaje["ext"]}");

        if (is_file($path_to_clone)) {
            unset($insert_archivo_mensaje[$this->id]);
            $insert_archivo_mensaje["mensajeVideoConsulta_idmensajeVideoConsulta"] = $idmensajeVideoConsulta;
            $newid = parent::insert($insert_archivo_mensaje);

            if ($newid) {

                $dir = new Dir(path_entity_files("{$this->getImgContainer()}/{$newid}"));

                $dir->chmod(0777);

                /**
                 * Copiamos todas las imágenes
                 */
                $path = path_entity_files("{$this->getImgContainer()}/{$newid}/{$insert_archivo_mensaje["nombre"]}.{$archivoMensaje["ext"]}");
                copy($path_to_clone, $path);

                return true;
            }
        }
        return false;
    }

    /**
     * Devolución del listado paginado de las imágenes pertenecientes a un mensaje de videoconsulta
     * Se le adjunta además la ubicación de las imágenes para fácil acceso en las View
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListImages($idmensajeVideoConsulta) {

        $query = new AbstractSql();

        $query->setSelect("t.*, CONCAT(nombre, '.', ext) as name_dropzone, $this->id as id_dropzone");

        $query->setFrom("$this->table t");

        $query->setWhere("t.mensajeVideoConsulta_idmensajeVideoConsulta = $idmensajeVideoConsulta");

        $listado = $this->getList($query);

        if ($listado) {
            //Recorro cada listado y le pongo el path
            foreach ($listado as $key => $value) {
                $value["nombre"] = str_replace(" ", "%20", $value["nombre"]);
                $listado[$key]["path_images_perfil"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "_perfil." . $value["ext"];
                $listado[$key]["path_images_usuario"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "_usuario." . $value["ext"];
                $listado[$key]["path_images_list"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "_list." . $value["ext"];
                $listado[$key]["path_images_gallery"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "." . $value["ext"];
                $listado[$key]["image_dropzone"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "_list." . $value["ext"];
               //si es PDF reemplazamos la miniatura por un icono
                if ($value["ext"] == "pdf") {
                    $listado[$key]["path_images"] = URL_ROOT . "xframework/app/themes/dp02/imgs/ico_pdf.png";
                } else {
                    $listado[$key]["path_images"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "." . $value["ext"];
                }
                $listado[$key]["url"] = URL_ROOT . "xframework/files/entities/mensajes_vc/" . $value[$this->id] . "/" . $value["nombre"] . "." . $value["ext"];
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna la cantidad de archivos que posee un mensaje
     * @param type $idmensajeVideoConsulta
     * @return type
     */
    public function getCantidadArchivosMensaje($idmensajeVideoConsulta) {

        $query = new AbstractSql();

        $query->setSelect("COUNT(t.{$this->id}) as cantidad");

        $query->setFrom("{$this->table} t");

        $query->setWhere("t.mensajeVideoConsulta_idmensajeVideoConsulta = {$idmensajeVideoConsulta}");

        return $this->db->GetRow($query->getSql());
    }

    /**
     * Método utilizado para eliminar el registro desde el dropzone
     * @param type $request
     */
    public function deleteDropzone($request) {
        if ((int) $request["id"] > 0) {
            $delete = parent::delete($request["id"]);
            if ($delete) {
                $this->setMsg(["msg" => "La imagen se eliminó con éxito", "result" => true]);
                return true;
            }
        }
        $this->setMsg(["msg" => "Error. No se pudo eliminar la imagen, recargue la página", "result" => false]);
        return false;
    }

}
