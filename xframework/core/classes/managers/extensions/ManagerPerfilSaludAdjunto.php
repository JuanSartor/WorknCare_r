<?php

/**
 * 	Manager del perfil de salud de adjunto correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludAdjunto extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludadjunto", "idperfilSaludAdjunto");

        $this->default_paginate = "perfil_salud_adjunto_list";
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
     * Método que procesa el upload múltiple de los archivos correspondientes a los adjunto de salud Adjunto
     * @param type $request
     * @return boolean
     */
    public function process_adjunto($request) {


            $request["fecha"] = date("d/m/Y");
        



        if (isset($request["fecha"]) && $request["fecha"] != "") {
            $request["fecha"] = $this->sqlDate($request["fecha"]);
        }

        $cantidad_archivos = (int) $request["cantidad"];
        if ($cantidad_archivos <= 0) {
            $this->setMsg([ "msg" => "Error, no ha seleccionado archivos", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $idperfil_salud_adjunto = parent::insert($request);
        if (!$idperfil_salud_adjunto) {
            $this->setMsg([ "msg" => "Error. No se pudo procesar el archivo", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
        $request["idperfilSaludAdjunto"] = $idperfil_salud_adjunto;

        $request["ext"] = "pdf";
        //Se procesan todas los archivos, con el nombre y demás..
        //Cantidad es el número de archivos subidas


        $ManagerPerfilSaludAdjuntoArchivo = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");

        $process = $ManagerPerfilSaludAdjuntoArchivo->insert($request);
        if (!$process) {
            $this->db->FailTrans();
            $this->setMsg([ "msg" => $ManagerPerfilSaludAdjuntoArchivo->getMsg()["msg"], "result" => false]);
            return false;
        }

        $this->setMsg([ "msg" => "Los archivos fueron subidos y procesados correctamente", "result" => true]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
     * Devolución del listado paginado de los perfiles de salud adjunto
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListAdjuntos($request, $idpaginate = null) {

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
            $ManagerPerfilSaludAdjuntoArchivo = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_archivos"] = $ManagerPerfilSaludAdjuntoArchivo->getListArchivos($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna la cantidad de adjuntos pertenecientes a un paciente
     * @param type $request
     * @return int
     */
    public function getCantAdjuntoPaciente($request) {
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
     * Método que retorna un listado de las archivos del médico 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListAdjuntoMedico($request, $idpaginate = null) {


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

        $query->setFrom("$this->table t ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("fecha DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado) {
            $ManagerPerfilSaludAdjuntoArchivo = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");
            //Recorro cada listado y le pongo el path
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_archivos"] = $ManagerPerfilSaludAdjuntoArchivo->getListArchivos($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que tiene un listado de adjuntos 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListAdjuntoConsulta($request) {

        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : $request["paciente_idpaciente"];

        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("t.*");

        $query->setFrom("$this->table t ");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado) {

            //Recorro cada listado y le pongo el path
            $ManagerPerfilSaludAdjuntoArchivo = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");
            foreach ($listado as $key => $value) {
                $listado[$key]["list_archivos"] = $ManagerPerfilSaludAdjuntoArchivo->getListArchivos($value["idperfilSaludAdjunto"]);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Eliminación múltiple de los registros. Además elimina los archivos a la adjunto seleccionada
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function deleteMultiple($ids, $forced = true) {
        $listado_ids = explode(",", $ids);
        //Obtengo los listados de ids
        if ($listado_ids && count($listado_ids) > 0) {
            $ManagerPerfilSaludAdjuntoArchivo = $this->getManager("ManagerPerfilSaludAdjuntoArchivo");

            //Recorro cada listado y dsp´s elimino
            foreach ($listado_ids as $key => $id) {
                if ((int) $id > 0) {
                    $adjunto_archivos = $ManagerPerfilSaludAdjuntoArchivo->getListArchivos($id);

                    if ($adjunto_archivos && count($adjunto_archivos) > 0) {
                        foreach ($adjunto_archivos as $key => $archivo) {
                            $delete = $ManagerPerfilSaludAdjuntoArchivo->delete($archivo["idperfilSaludAdjuntoArchivo"]);
                        }
                    }
                    $delete_estudio = parent::delete($id, true);
                }
            }

            $this->setMsg([ "msg" => "Se eliminaron todos los archivos con éxito", "result" => true]);
            return true;
        }
        $this->setMsg([ "msg" => "Error. No se pudo eliminar los archivos", "result" => false]);
        return false;
    }

  

    /**
     * Metodo que devuleve si una consulta medica posee adjunto o no
     * @param type $idperfilSaludConsulta
     */
    public function posee_adjunto($idperfilSaludConsulta) {
        $consulta = $this->getManager("ManagerPerfilSaludConsulta")->get($idperfilSaludConsulta);
        if ($consulta["adjunto_disponible_consultorio"] == 1) {
            return 1;
        } else {
            $adjunto = $this->getByField("perfilSaludConsulta_idperfilSaludConsulta", $idperfilSaludConsulta);
            if ($adjunto) {
                return true;
            }
        }
        return 0;
    }

}

//END_class
?>