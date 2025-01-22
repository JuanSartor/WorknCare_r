<?php

/**
 * 	Manager del archivos de recetas correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludRecetaArchivo extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludreceta_archivo", "idperfilSaludRecetaArchivo");

        $this->default_paginate = "perfil_salud_receta_archivo_list";
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
     * Método que procesa el upload múltiple de los archivos correspondientes a las recetas
     * @param type $request
     * @return boolean
     */
    public function insert($request) {

        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];

        $request["perfilSaludReceta_idperfilSaludReceta"] = $request["idperfilSaludReceta"];
        //Flag para verificar si ocurre algún error.
        $flag_file_true = false;
        //Variable para ver si hay archivos
        $exist_files = false;
        $cantidad_file = $request["cantidad"];
        if (!file_exists(path_entity_files("receta_archivo/{$request["idperfilSaludReceta"]}"))) {
            mkdir(path_entity_files("receta_archivo/{$request["idperfilSaludReceta"]}"), 0777, true);
        }
        for ($i = 0; $i < $cantidad_file; $i++) {
            //Por cada cantidad tiene que haber un archivo insertado en la carpeta temporal "documentacion_medico"
            //Me fijo si existe el path
            if (isset($_SESSION[$hash][$i])) {
                $exist_files = true;

                $path = path_root("{$datos_session[$i]["path"]}");

                //Si existe el path, se inserta el archvio
                if (is_file($path)) {


                    $request["nombre_archivo"] = "{$datos_session[$i]["filename"]}";
                    $request["ext"] = "{$datos_session[$i]["ext"]}";

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
                        $code = $this->getRandomCode(8);
                        parent::update(["codigo" => $code], $rdo);

                        $_SESSION[$hash] = $datos_session;

                        //Copio todos los archivos
                        rename(path_files("temp/receta_archivo/{$hash}/{$i}.{$request["ext"]}"), path_entity_files("receta_archivo/{$request["idperfilSaludReceta"]}/{$request["nombre_archivo"]}.{$request["ext"]}"));
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

    public function crear_receta_electronica($id) {

        $receta_archivo = parent::get($id);
        $data_variables["receta_archivo"] = $receta_archivo;
        $perfil_salud_receta = $this->getManager("ManagerPerfilSaludReceta")->get($receta_archivo["perfilSaludReceta_idperfilSaludReceta"]);
        $consulta = $this->getManager("ManagerPerfilSaludConsulta")->get($perfil_salud_receta["perfilSaludConsulta_idperfilSaludConsulta"]);
        $data_variables["consulta"] = $consulta;
        $videoconsulta = $this->getManager("ManagerVideoconsulta")->get($consulta["videoconsulta_idvideoconsulta"]);
        $data_variables["videoconsulta"] = $videoconsulta;


        $medico = $this->getManager("ManagerMedico")->get($consulta["medico_idmedico"], 1);
        $data_variables["medico"] = $medico;
        $paciente = $this->getManager("ManagerPaciente")->get($consulta["paciente_idpaciente"]);
        $data_variables["paciente"] = $paciente;

        $data_variables["file"] = path_files("entities/receta_archivo/{$receta_archivo["perfilSaludReceta_idperfilSaludReceta"]}/{$receta_archivo["nombre_archivo"]}.{$receta_archivo["ext"]}");


        $PDFRecetaElectronica = new PDFRecetaElectronica();

        $PDFRecetaElectronica->getPDF($data_variables);
    }

    public function get_receta_electronica($codigo, $preview = false) {

        $receta_archivo = parent::getByField("codigo", $codigo);
        $data_variables["receta_archivo"] = $receta_archivo;

        $data_variables["farmacia"] = 1;
        if ($preview) {
            $data_variables["preview"] = 1;
        }

        $data_variables["file"] = path_files("entities/receta_archivo/{$receta_archivo["perfilSaludReceta_idperfilSaludReceta"]}/{$receta_archivo["nombre_archivo"]}.{$receta_archivo["ext"]}");

        $PDFRecetaElectronica = new PDFRecetaElectronica();

        $PDFRecetaElectronica->getPDF($data_variables);
    }

    /**
     * @author Sebastian Balestrini
     * @version 1.0
     * Genera una clave aleatoria de $logitud digitos alfanumericos
     * @param int $length tama�o del password a devolver 
     * @return string password aleatoria
     */
    public function getRandomCode($length) {

        $template = "1234567890ABCDEFGHJKLMNOPQRSTUVWXYZ";

        settype($length, "integer");
        settype($rndstring, "string");
        settype($a, "integer");
        settype($b, "integer");

        for ($a = 0; $a <= $length; $a++) {
            $b = rand(0, strlen($template) - 1);
            $rndstring .= $template[$b];
        }

        return $rndstring;
    }

    /**
     * Devolución del listado paginado de las recetas
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListArchivos($idperfilSaludReceta) {

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.perfilSaludReceta_idperfilSaludReceta = $idperfilSaludReceta");

        $listado = $this->getList($query);

        if ($listado) {
            //Recorro cada listado y le pongo el path

            foreach ($listado as $key => $value) {
                //fix archivos con espacios en filename 
                $value["nombre_archivo"] = str_replace(" ", "%20", $value["nombre_archivo"]);
                $listado[$key]["path"] = URL_ROOT . "xframework/files/entities/receta_archivo/{$idperfilSaludReceta}/{$value["nombre_archivo"]}.{$value["ext"]}";
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

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado) {
            //Recorro cada listado y le pongo el path
            foreach ($listado as $key => $value) {
                $listado[$key]["path"] = URL_ROOT . "xframework/files/entities/receta_archivo/" . $idperfilSaludConsulta . "/" . $value["nombre_archivo"] . ".pdf";
            }
            return $listado;
        } else {
            return false;
        }
    }

    public function get($id, $query = NULL, $alias = NULL) {
        $rdo = parent::get($id, $query, $alias);
        if ($rdo) {

            $rdo["path"] = URL_ROOT . "xframework/files/entities/receta_archivo/" . $rdo[$this->id] . "/" . $rdo["nombre_archivo"] . ".pdf";


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


        $dir = path_files("temp/receta_archivo/{$id}");

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
                    $archivo_receta = parent::get($id);
                    $rdo = parent::delete($id, true);
                    if ($rdo) {
                        $path_remove = path_entity_files("receta_archivo/{$archivo_receta["perfilSaludReceta_idperfilSaludReceta"]}/{$archivo_receta["nombre_archivo"]}.{$archivo_receta["ext"]}");
                        unlink($path_remove);
                    } else {
                        $result = false;
                    }
                    //vemos si quedan archivos, sino eliminamos el registro de la cabecera de receta
                    $archivos_restantes = $this->db->getOne("select count(*) as cant from {$this->table} where perfilSaludReceta_idperfilSaludReceta={$archivo_receta["perfilSaludReceta_idperfilSaludReceta"]}");
                    if ($archivos_restantes["cant"] == 0) {
                        $this->getManager("ManagerPErfilSaludReceta")->delete($archivo_receta["perfilSaludReceta_idperfilSaludReceta"], true);
                    }
                }
            }

            if ($result) {
                $this->setMsg(["result" => true, "msg" => "Se eliminaron las recetas con éxito"]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "Error. No se pudo eliminar las recetas"]);
                return false;
            }
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No hay recetas seleccionadas"]);
            return false;
        }
    }

}

//END_class
?>