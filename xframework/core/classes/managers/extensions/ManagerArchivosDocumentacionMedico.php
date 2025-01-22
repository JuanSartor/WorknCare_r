<?php

/**
 * ManagerArchivosDocumentacionMedico administra los archivos contenidos en la docuemntacion del medico adjuntada por el admin
 *
 *
 * @author lucas
 */
class ManagerArchivosDocumentacionMedico extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "archivosdocumentacionmedico", "idarchivosDocumentacionMedico");

        $this->setImgContainer("documentacion_medico");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
        $this->addThumbConfig(500, 384, "_gallery", true);
    }

    /**
     * Método que procesa el upload de los archivos de documentacion
     * @param type $request
     * @return boolean
     */
    public function process($request) {


        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];

        $request["documentacionMedico_iddocumentacionMedico"] = $request["iddocumentacionMedico"];
        //Flag para verificar si ocurre algún error.
        $flag_file_true = false;
        //Variable para ver si hay archivos
        $exist_files = false;
        if ($request["cantidad_file"] != "") {
            $cantidad_file = $request["cantidad_file"];
        }
        if ($request["cantidad"] != "") {
            $cantidad_file = $request["cantidad"];
        }

        if (!file_exists(path_entity_files("documentacion_medico/{$request["iddocumentacionMedico"]}"))) {
            mkdir(path_entity_files("documentacion_medico/{$request["iddocumentacionMedico"]}"), 0777, true);
        }
        for ($i = 0; $i < $cantidad_file; $i++) {
            //Por cada cantidad tiene que haber un archivo insertado en la carpeta temporal "documentacion_medico"
            //Me fijo si existe el path
            if (isset($_SESSION[$hash][$i])) {
                $exist_files = true;

                $path = path_root("{$datos_session[$i]["path"]}");

                //Si existe el path, se inserta el archvio
                if (is_file($path)) {

                    $nombre = explode(".", $datos_session[$i]["name"]);
                    $request["nombre"] = str2seo($nombre[0]);
                    $request["ext"] = strtolower($nombre[1]);

                    if ($request["ext"] == "exe") {
                        $this->setMsg(["msg" => "Error. No se pudo insertar el archivo [[{$request["nombre_archivo"] }]]", "result" => false]);
                        return false;
                    }
                    $rdo = parent::insert($request);

                    if (!$rdo) {
                        $this->setMsg(["msg" => "Error. No se pudo insertar el archivo [[{$request["nombre_archivo"] }]]", "result" => false]);
                        return false;
                    } else {
                        $flag_file_true = true;

                        $_SESSION[$hash] = $datos_session;

                        //Copio todos los archivos
                        rename(path_files("temp/documentacion_medico/{$hash}/{$i}.{$request["ext"]}"), path_entity_files("documentacion_medico/{$request["iddocumentacionMedico"]}/{$request["nombre"]}.{$request["ext"]}"));
                    }
                }
            }
        }

        if ($flag_file_true && $exist_files) {
            $this->setMsg(["msg" => "Los archivos fueron subidos y procesadas correctamente", "result" => true]);
            return true;
        } else if ($flag_file_true == false && $exist_files) {
            //Se produjo un error y existen imágenes
            $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No hay archivos para insertar", "result" => false]);
            return false;
        }
    }

    /**
     * Devolución del listado paginado de las imágenes pertenecientes a un mensaje de consulta express
     * Se le adjunta además la ubicación de las imágenes para fácil acceso en las View
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListadoArchivosDocumentacionMedico($iddocumentacionMedico) {

        if ((int) $iddocumentacionMedico > 0) {


            $query = new AbstractSql();

            $query->setSelect("t.*, CONCAT(nombre, '.', ext) as filename");

            $query->setFrom("$this->table t");

            $query->setWhere("t.documentacionMedico_iddocumentacionMedico = $iddocumentacionMedico");

            $listado = $this->getList($query);

            if ($listado) {
                //Recorro cada listado y le pongo el path
                foreach ($listado as $key => $value) {
                    //fix archivos con espacios en filename 
                    $value["nombre"] = str_replace(" ", "%20", $value["nombre"]);
                    $listado[$key]["path"] = URL_ROOT . "xframework/files/entities/documentacion_medico/" . $iddocumentacionMedico . "/" . $value["nombre"] . "." . $value["ext"];

                    if (in_array(strtolower($value["ext"]), ["jpg", "png", "jpeg"])) {
                        $listado[$key]["type"] = "image";
                    } else {
                        $listado[$key]["type"] = "file";

                        switch ($value["ext"]) {
                            case "txt":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_txt.png";
                                break;
                            case "doc":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_docx.png";
                                break;
                            case "docx":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_docx.png";
                                break;
                            case "pdf":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_pdf.png";
                                break;
                            case "xlsx":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_xlsx.png";
                                break;
                            case "xls":
                                $listado[$key]["icon"] = URL_ROOT . "xframework/app/themes/" . THEME . "/imgs/ico_xlsx.png";
                                break;
                        }
                    }

                    // acortamos el nombre
                    if (strlen($value["filename"]) > 18) {
                        $listado[$key]["filename_format"] = substr($value["filename"], 0, 18) . "...";
                    } else {
                        $listado[$key]["filename_format"] = $value["filename"];
                    }
                }

                return $listado;
            } else {
                return false;
            }
        }
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
