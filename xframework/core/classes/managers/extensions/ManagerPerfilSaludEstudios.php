<?php

/**
 * 	Manager del perfil de salud de estudios e imágenes correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludEstudios extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludestudios", "idperfilSaludEstudios");

        $this->default_paginate = "perfil_salud_estudios_list";
    }

    public function process($request) {

        $rdo = parent::process($request);

        if (!$rdo) {
            $this->setMsg([ "result" => false, "msg" => "Se produjo un error, verifique los datos"]);
            return false;
        } else {
            $this->setMsg([ "result" => true, "msg" => "Se han guardado los datos correctamente", "id" => $rdo]);
            return $rdo;
        }
    }

    /**
     * Método que procesa el upload múltiple de las imágenes correspondientes a los estudios de salud Estudios
     * @param type $request
     * @return boolean
     */
    public function processImage($request) {

        if ($request["perfilSaludConsulta_idperfilSaludConsulta"] != "") {
            $request["fecha"] = date("d/m/Y");
        }

        $request["fecha"] = isset($request["fecha"]) && $request["fecha"] != "" ? $request["fecha"] : date("d/m/Y");

        if ($request["fecha"] == "" || $request["titulo"] == "") {
            $this->setMsg([ "msg" => "Complete los campos obligatorios", "result" => false]);
            return false;
        }


        if (isset($request["fecha"]) && $request["fecha"] != "") {
            $request["fecha"] = $this->sqlDate($request["fecha"]);
        }

        $cantidad_imagenes = (int) $request["cantidad"];
        if ($cantidad_imagenes <= 0) {
            $this->setMsg([ "msg" => "Error, no ha seleccionado imágenes", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $idperfil_salud_estudios = parent::insert($request);
        if (!$idperfil_salud_estudios) {
            $this->setMsg([ "msg" => "Error. No se pudo procesar el estudio, verifique los campos ingresados", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
        $request["perfilSaludEstudios_idperfilSaludEstudios"] = $idperfil_salud_estudios;

        $request["ext"] = "jpg";
        //Se procesan todas las imágenes, con el nombre y demás..
        //Cantidad es el número de imágenes subidas

        // <-- LOG
        $log["data"] = "Register List of pictures and files : add data";
        $log["page"] = "Health Profile";
        $log["action"] = "val"; //"val" "vis" "del"
        $log["purpose"] = "See information Health Profile";
        //
        //        
        $ManagerLog = $this->getManager("ManagerLog");
        $ManagerLog->track($log);
        // <--
        $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");

        $process = $ManagerPerfilSaludEstudiosImagen->processAllFiles($request);
        if (!$process) {
            $this->db->FailTrans();
            $this->setMsg([ "msg" => $ManagerPerfilSaludEstudiosImagen->getMsg()["msg"], "result" => false]);
            return false;
        }

        $this->setMsg([ "msg" => "Las imágenes fueron subidas y procesadas correctamente", "result" => true]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
     * Copia de los archivos de mensajes de consulta express 
     * @param type $idconsultaExpress
     * @return boolean
     */
    public function processFromConsultaExpress($idconsultaExpress, $is_paciente = true) {

        $CE = $this->getManager("ManagerConsultaExpress")->get($idconsultaExpress);

        $query = new AbstractSql();

        $query->setSelect("amce.*");

        $query->setFrom("mensajeconsultaexpress mce 
                            INNER JOIN archivosmensajeconsultaexpress amce ON (mce.idmensajeConsultaExpress = amce.mensajeConsultaExpress_idmensajeConsultaExpress)");

        $query->setWhere("mce.consultaExpress_idconsultaExpress = {$idconsultaExpress}");

//          if ($is_paciente) {
//              $query->addAnd("mce.emisor = 'P'");
//          } else {
//              $query->addAnd("mce.emisor = 'M'");
//          }

        $listado = $this->getList($query);
        if (count($listado) == 0) {
            return true;
        }

        if ($listado && count($listado) > 0) {
            $consulta_medica = $this->getManager("ManagerPerfilSaludConsulta")->getByField("consultaExpress_idconsultaExpress", $idconsultaExpress);

            //Si hay archivos, creo el estudio
            $insert_estudio = parent::insert([
                        "fecha" => date("Y-m-d H:i:s"),
                        "titulo" => "Conseil Nº {$CE["numeroConsultaExpress"]}",
                        "paciente_idpaciente" => $CE["paciente_idpaciente"],
                        "perfilSaludConsulta_idperfilSaludConsulta" => $consulta_medica["idperfilSaludConsulta"]
            ]);

            if ($insert_estudio) {
                // <-- LOG
                $log["data"] = "Register List of pictures and files : add data";
                $log["page"] = "Health Profile";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "See information Health Profile";
                //
                //        
                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // <--
                $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
                foreach ($listado as $key => $value) {

                    if (is_file(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}.{$value["ext"]}"))) {

                        //Perfil saludo estudios imagen
                        $insert_estudio_imagen = $ManagerPerfilSaludEstudiosImagen->insert([
                            "nombre_archivo" => $value["nombre"],
                            "ext" => $value["ext"],
                            "perfilSaludEstudios_idperfilSaludEstudios" => $insert_estudio
                        ]);

                        if ($insert_estudio_imagen) {
                            //Copio todos los archivos
                            copy(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}_perfil.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_perfil.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}_usuario.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_usuario.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}_list.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_list.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_ce/{$value["idarchivosMensajeConsultaExpress"]}/{$value["nombre"]}_gallery.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_gallery.{$value["ext"]}"));
                        }
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Copia de los archivos de mensajes de video consulta
     * @param type $idvideoconsulta
     * @return boolean
     */
    public function processFromVideoConsulta($idvideoconsulta) {

        $VC = $this->getManager("ManagerVideoConsulta")->get($idvideoconsulta);

        $query = new AbstractSql();

        $query->setSelect("amvc.*");

        $query->setFrom("mensajevideoconsulta mvc 
                            INNER JOIN archivosmensajevideoconsulta amvc ON (mvc.idmensajeVideoConsulta = amvc.mensajeVideoConsulta_idmensajeVideoConsulta)");

        $query->setWhere("mvc.videoconsulta_idvideoconsulta = {$idvideoconsulta}");



        $listado = $this->getList($query);

        if (count($listado) > 0) {

            $consulta_medica = $this->getManager("ManagerPerfilSaludConsulta")->getByField("videoconsulta_idvideoconsulta", $idvideoconsulta);
            //Si hay archivos, creo el estudio
            $insert_estudio = parent::insert([
                        "fecha" => date("Y-m-d H:i:s"),
                        "titulo" => "Vidéo Consultation Nº {$VC["numeroVideoConsulta"]}",
                        "paciente_idpaciente" => $VC["paciente_idpaciente"],
                        "perfilSaludConsulta_idperfilSaludConsulta" => $consulta_medica["idperfilSaludConsulta"]
            ]);

            if ($insert_estudio) {
                // <-- LOG
                $log["data"] = "Register List of pictures and files : add data";
                $log["page"] = "Health Profile";
                $log["action"] = "val"; //"val" "vis" "del"
                $log["purpose"] = "See information Health Profile";
                //
                //        
                $ManagerLog = $this->getManager("ManagerLog");
                $ManagerLog->track($log);
                // <--
                $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
                foreach ($listado as $key => $value) {

                    if (is_file(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}.{$value["ext"]}"))) {

                        //Perfil saludo estudios imagen
                        $insert_estudio_imagen = $ManagerPerfilSaludEstudiosImagen->insert([
                            "nombre_archivo" => $value["nombre"],
                            "ext" => $value["ext"],
                            "perfilSaludEstudios_idperfilSaludEstudios" => $insert_estudio
                        ]);

                        if ($insert_estudio_imagen) {
                            //Copio todos los archivos
                            copy(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}_perfil.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_perfil.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}_usuario.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_usuario.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}_list.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_list.{$value["ext"]}"));

                            copy(path_entity_files("mensajes_vc/{$value["idarchivosMensajeVideoConsulta"]}/{$value["nombre"]}_gallery.{$value["ext"]}"), path_entity_files("estudios_imagenes/{$insert_estudio_imagen}/{$value["nombre"]}_gallery.{$value["ext"]}"));
                        }
                    }
                }
                return true;
            } else {
                return false;
            }
        }

        return true;
    }

    /**
     * Devolución del listado paginado de los perfiles de salud estudios
     * Se le adjunta además la ubicación de las imágenes para fácil acceso en las View
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListImages($request, $idpaginate = null) {

        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 12);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $idpaciente = $request["idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("fecha DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado["rows"] && count($listado["rows"]) > 0) {
            //Recorro cada listado y le pongo el path
            $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_imagenes"] = $ManagerPerfilSaludEstudiosImagen->getListImages($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna la cantidad de imagenes pertenecientes a un paciente
     * @param type $request
     * @return int
     */
    public function getCantEstudiosPaciente($request) {
        $idpaciente = $request["idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("COUNT(t.$this->id) as cantidad");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setGroupBy("t.paciente_idpaciente");

        $execute = $this->db->Execute($query->getSql());

        if ($execute) {
            $rdo = $execute->FetchRow();
            if ($rdo) {
                return (int) $rdo["cantidad"];
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    }

    /**
     * Método que retorna un listado de las imágenes del médico 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListEstudiosMedico($request, $idpaginate = null) {


        if (isset($request["do_reset"]) && $request["do_reset"] == 1) {
            $this->resetPaginate($idpaginate);
        }

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 12);
        }

        //Seteo el current page
        $request["current_page"] = $request["current_page"] != "" ? $request["current_page"] : 1;
        SmartyPaginate::setCurrentPage($request["current_page"], $idpaginate);

        $idpaciente = $request["idpaciente"];

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("fecha DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado) {
            $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
            //Recorro cada listado y le pongo el path
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_imagenes"] = $ManagerPerfilSaludEstudiosImagen->getListImages($value[$this->id]);
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
    public function getListEstudiosConsulta($request) {

        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : $request["paciente_idpaciente"];

        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado && count($listado) > 0) {
            //Recorro cada listado y le pongo el path
            $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
            foreach ($listado as $key => $value) {
                $listado[$key]["list_imagenes"] = $ManagerPerfilSaludEstudiosImagen->getListImages($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Eliminación múltiple de los registros. Además elimina las imágenes referidas al estudio seleccionado
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function deleteMultiple($ids, $forced = true) {
        $listado_ids = explode(",", $ids);
        //Obtengo los listados de ids
        if ($listado_ids && count($listado_ids) > 0) {
            $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");

            //Recorro cada listado y dsp´s elimino
            foreach ($listado_ids as $key => $id) {
                if ((int) $id > 0) {
                    $estudios_imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages($id);

                    if ($estudios_imagenes && count($estudios_imagenes) > 0) {
                        foreach ($estudios_imagenes as $key => $imagen) {
                            $delete = $ManagerPerfilSaludEstudiosImagen->delete($imagen["idperfilSaludEstudiosImagen"]);
                        }
                    }
                    $delete_estudio = parent::delete($id, true);
                }
            }
            
            // <-- LOG
            $log["data"] = "Register List of pictures and files : delete data";
            $log["page"] = "Health Profile";
            $log["action"] = "val"; //"val" "vis" "del"
            $log["purpose"] = "See information Health Profile";
            //
            //        
            $ManagerLog = $this->getManager("ManagerLog");
            $ManagerLog->track($log);
            // <--
        
            $this->setMsg([ "msg" => "Se han eliminado los Estudios seleccionados", "result" => true]);
            return true;
        }
        $this->setMsg([ "msg" => "Error. No se han podido eliminar el/los Estudio/s seleccionado/s", "result" => false]);
        return false;
    }

}

//END_class
?>