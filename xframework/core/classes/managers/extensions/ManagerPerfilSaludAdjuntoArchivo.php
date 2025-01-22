<?php

/**
 * 	Manager del archivos de adjuntos correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludAdjuntoArchivo extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludadjunto_archivo", "idperfilSaludAdjuntoArchivo");

        $this->default_paginate = "perfil_salud_adjunto_archivo_list";
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
     * Método que procesa el upload múltiple de los archivos correspondientes a los adjuntos
     * @param type $request
     * @return boolean
     */
    public function insert($request) {


        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];

        $request["perfilSaludAdjunto_idperfilSaludAdjunto"] = $request["idperfilSaludAdjunto"];
        //Flag para verificar si ocurre algún error.
        $flag_file_true = false;
        //Variable para ver si hay archivos
        $exist_files = false;
        $cantidad_file = $request["cantidad"];
        if (!file_exists(path_entity_files("adjunto_archivo/{$request["idperfilSaludAdjunto"]}"))) {
            mkdir(path_entity_files("adjunto_archivo/{$request["idperfilSaludAdjunto"]}"), 0777, true);
        }
        for ($i = 0; $i < $cantidad_file; $i++) {
            //Por cada cantidad tiene que haber un archivo insertado en la carpeta temporal "documentacion_medico"
            //Me fijo si existe el path
            if (isset($_SESSION[$hash][$i])) {
                $exist_files = true;

                $path = path_root("{$datos_session[$i]["path"]}");

                //Si existe el path, se inserta el archvio
                if (is_file($path)) {

                    $nombre = str_replace('.pdf', '', $datos_session[$i]["name"]);
                    $nombre = str2seo($nombre);
                    $request["nombre_archivo"] = $nombre;
                    $request["ext"] = "pdf";


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
                        rename(path_files("temp/adjunto_archivo/{$hash}/{$i}.{$request["ext"]}"), path_entity_files("adjunto_archivo/{$request["idperfilSaludAdjunto"]}/{$request["nombre_archivo"]}.{$request["ext"]}"));
                    }
                }
            }
        }

        if ($flag_file_true && $exist_files) {
            $this->setMsg(["msg" => "Los archivos fueron subidos y procesadas correctamente", "result" => true]);
            return true;
        } else if ($flag_file_true == false && $exist_files) {
            //Se produjo un error 
            $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No hay archivos para insertar", "result" => false]);
            return false;
        }
    }

    public function crear_adjunto_electronica($id) {

        $adjunto_archivo = parent::get($id);
        $data_variables["adjunto_archivo"] = $adjunto_archivo;
        $perfil_salud_adjunto = $this->getManager("ManagerPerfilSaludAdjunto")->get($adjunto_archivo["perfilSaludAdjunto_idperfilSaludAdjunto"]);
        $consulta = $this->getManager("ManagerPerfilSaludConsulta")->get($perfil_salud_adjunto["perfilSaludConsulta_idperfilSaludConsulta"]);
        $data_variables["consulta"] = $consulta;
        $videoconsulta = $this->getManager("ManagerVideoconsulta")->get($consulta["videoconsulta_idvideoconsulta"]);
        $data_variables["videoconsulta"] = $videoconsulta;


        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"], 1);
        $data_variables["medico"] = $medico;
        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
        $data_variables["paciente"] = $paciente;

        $data_variables["file"] = path_files("entities/adjunto_archivo/{$adjunto_archivo["perfilSaludAdjunto_idperfilSaludAdjunto"]}/{$adjunto_archivo["nombre_archivo"]}.{$adjunto_archivo["ext"]}");


        $PDFAdjuntoElectronica = new PDFAdjuntoElectronica();

        $PDFAdjuntoElectronica->getPDF($data_variables);
    }

    /**
     * Devolución del listado paginado de adjuntos
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListArchivos($idperfilSaludAdjunto) {

        $query = new AbstractSql();

        $query->setSelect("t.*, t.nombre_archivo as titulo");

        $query->setFrom("$this->table t");

        $query->setWhere("t.perfilSaludAdjunto_idperfilSaludAdjunto = $idperfilSaludAdjunto");

        $listado = $this->getList($query);

        if ($listado) {
            //Recorro cada listado y le pongo el path

            foreach ($listado as $key => $value) {
                $value["nombre_archivo"] = str_replace(" ", "%20", $value["nombre_archivo"]);
                $listado[$key]["path"] = URL_ROOT . "xframework/files/entities/adjunto_archivo/{$idperfilSaludAdjunto}/{$value["nombre_archivo"]}.{$value["ext"]}";
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que tiene un listado de archivos 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListArchivosConsulta($request) {


        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : $request["paciente_idpaciente"];

        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("t.*, t.nombre_archivo as titulo");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado) {
            //Recorro cada listado y le pongo el path
            foreach ($listado as $key => $value) {
                 //fix archivos con espacios en filename 
                $value["nombre_archivo"] = str_replace(" ", "%20", $value["nombre_archivo"]);
                $listado[$key]["path"] = URL_ROOT . "xframework/files/entities/adjunto_archivo/" . $idperfilSaludConsulta . "/" . $value["nombre_archivo"] . ".pdf";
            }
            return $listado;
        } else {
            return false;
        }
    }

    public function get($id, $query = NULL, $alias = NULL) {
        $rdo = parent::get($id, $query, $alias);
        if ($rdo) {

            $rdo["path"] = URL_ROOT . "xframework/files/entities/adjunto_archivo/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . ".pdf";


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
    public function cancelarUploadArchivo($id) {


        $dir = path_files("temp/adjunto_archivo/{$id}");

        if (is_dir($dir)) {

            $class_dir = new Dir();
            $class_dir->deleteDir($dir);

            rmdir($dir);

            $this->setMsg(["msg" => "Se ha cancelado con éxito", "result" => true]);
            return true;
        } else {
            $this->setMsg(["msg" => "No hay archivos subidos para cancelar", "result" => false]);
            return false;
        }
    }

    /**
     * Delete múltiple de los archivos
     * @param type $ids
     * @return boolean
     */
    public function deleteMultiple($ids) {

        $listado_ids = explode(",", $ids);
        if ($listado_ids && count($listado_ids) > 0) {
            $result = true;

            foreach ($listado_ids as $key => $id) {
                if ($id != "") {
                    $archivo_adjunto = parent::get($id);
                    $rdo = parent::delete($id, true);
                    if ($rdo) {
                        $path_remove = path_entity_files("adjunto_archivo/{$archivo_adjunto["perfilSaludAdjunto_idperfilSaludAdjunto"]}/{$archivo_adjunto["nombre_archivo"]}.{$archivo_adjunto["ext"]}");
                        unlink($path_remove);
                    } else {
                        $result = false;
                    }
                    //vemos si quedan archivos, sino eliminamos el registro de la cabecera de adjunto
                    $archivos_restantes = $this->db->getOne("select count(*) as cant from {$this->table} where perfilSaludAdjunto_idperfilSaludAdjunto={$archivo_adjunto["perfilSaludAdjunto_idperfilSaludAdjunto"]}");
                    if ($archivos_restantes["cant"] == 0) {
                        $this->getManager("ManagerPErfilSaludAdjunto")->delete($archivo_adjunto["perfilSaludAdjunto_idperfilSaludAdjunto"], true);
                    }
                }
            }

            if ($result) {
                $this->setMsg(["result" => true, "msg" => "Se eliminaron todos los archivos con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo eliminar los archivos"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "No hay archivos seleccionadoss"]);
            return false;
        }
    }

}

//END_class
?>