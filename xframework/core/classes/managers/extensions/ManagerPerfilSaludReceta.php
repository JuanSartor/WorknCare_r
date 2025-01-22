<?php

/**
 * 	Manager del perfil de salud de receta correspondientes a los pacientes
 *
 * 	@author Xinergia
 * 	@version 1.0
 * 	@package managers\extensions
 */
class ManagerPerfilSaludReceta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Constructor
        parent::__construct($db, "perfilsaludreceta", "idperfilSaludReceta");

        $this->default_paginate = "perfil_salud_receta_list";
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
     * Método que procesa el upload múltiple de los archivos correspondientes a los receta de salud Receta
     * @param type $request
     * @return boolean
     */
    public function process_receta($request) {


        if ($request["perfilSaludConsulta_idperfilSaludConsulta"] != "") {
            $request["fecha"] = date("d/m/Y");
        }

        $request["fecha"] = isset($request["fecha"]) && $request["fecha"] != "" ? $request["fecha"] : date("d/m/Y");

        if ($request["fecha"] == "" || $request["tipo_receta_idtipo_receta"] == "") {
            $this->setMsg([ "msg" => "Complete los campos obligatorios", "result" => false]);
            return false;
        }


        if (isset($request["fecha"]) && $request["fecha"] != "") {
            $request["fecha"] = $this->sqlDate($request["fecha"]);
        }

        $cantidad_archivos = (int) $request["cantidad"];
        if ($cantidad_archivos <= 0) {
            $this->setMsg([ "msg" => "Error, no ha seleccionado archivos", "result" => false]);
            return false;
        }

        $this->db->StartTrans();
        $idperfil_salud_receta = parent::insert($request);
        if (!$idperfil_salud_receta) {
            $this->setMsg([ "msg" => "Error. No se pudo procesar la receta, verifique los campos ingresados", "result" => false]);
            $this->db->FailTrans();
            return false;
        }
        $request["idperfilSaludReceta"] = $idperfil_salud_receta;

        $request["ext"] = "pdf";
        //Se procesan todas los archivos, con el nombre y demás..
        //Cantidad es el número de archivos subidas


        $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");

        $process = $ManagerPerfilSaludRecetaArchivo->insert($request);
        if (!$process) {
            $this->db->FailTrans();
            $this->setMsg([ "msg" => $ManagerPerfilSaludRecetaArchivo->getMsg()["msg"], "result" => false]);
            return false;
        }

        $this->setMsg([ "msg" => "Los archivos fueron subidos y procesados correctamente", "result" => true]);
        $this->db->CompleteTrans();
        return true;
    }

    /**
     * Devolución del listado paginado de los perfiles de salud receta
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListRecetas($request, $idpaginate = null) {

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

        $query->setSelect("t.*,tr.tipo_receta");

        $query->setFrom("$this->table t INNER JOIN tipo_receta tr ON (t.tipo_receta_idtipo_receta=tr.idtipo_receta)");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("fecha DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado["rows"] && count($listado["rows"]) > 0) {
            //Recorro cada listado y le pongo el path
            $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_archivos"] = $ManagerPerfilSaludRecetaArchivo->getListArchivos($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que retorna la cantidad de recetas pertenecientes a un paciente
     * @param type $request
     * @return int
     */
    public function getCantRecetaPaciente($request) {
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
    public function getListRecetaMedico($request, $idpaginate = null) {

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

        $query->setSelect("t.*,tr.tipo_receta");

        $query->setFrom("$this->table t INNER JOIN tipo_receta tr ON (t.tipo_receta_idtipo_receta=tr.idtipo_receta)");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->setOrderBy("fecha DESC");

        $listado = $this->getListPaginado($query, $idpaginate);

        if ($listado) {
            $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");
            //Recorro cada listado y le pongo el path
            foreach ($listado["rows"] as $key => $value) {
                $listado["rows"][$key]["list_archivos"] = $ManagerPerfilSaludRecetaArchivo->getListArchivos($value[$this->id]);
            }
            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Método que tiene un listado de recetas 
     * @param type $request
     * @param type $idpaginate
     * @return string|boolean
     */
    public function getListRecetaConsulta($request) {

        $idpaciente = isset($request["idpaciente"]) && $request["idpaciente"] != "" ? $request["idpaciente"] : $request["paciente_idpaciente"];

        $idperfilSaludConsulta = $request["idperfilSaludConsulta"];

        $query = new AbstractSql();

        $query->setSelect("t.*, tr.tipo_receta");

        $query->setFrom("$this->table t INNER JOIN tipo_receta tr ON (t.tipo_receta_idtipo_receta=tr.idtipo_receta)");

        $query->setWhere("t.paciente_idpaciente = $idpaciente");

        $query->addAnd("t.perfilSaludConsulta_idperfilSaludConsulta = $idperfilSaludConsulta");

        $listado = $this->getList($query, false);

        if ($listado) {


            //Recorro cada listado y le pongo el path
            $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");
            foreach ($listado as $key => $value) {
                $listado[$key]["list_archivos"] = $ManagerPerfilSaludRecetaArchivo->getListArchivos($value["idperfilSaludReceta"]);
            }

            return $listado;
        } else {
            return false;
        }
    }

    /**
     * Eliminación múltiple de los registros. Además elimina los archivos a la receta seleccionada
     * @param type $ids
     * @param type $forced
     * @return boolean
     */
    public function deleteMultiple($ids, $forced = true) {
        $listado_ids = explode(",", $ids);
        //Obtengo los listados de ids
        if ($listado_ids && count($listado_ids) > 0) {
            $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");

            //Recorro cada listado y dsp´s elimino
            foreach ($listado_ids as $key => $id) {
                if ((int) $id > 0) {
                    $receta_archivos = $ManagerPerfilSaludRecetaArchivo->getListArchivos($id);

                    if ($receta_archivos && count($receta_archivos) > 0) {
                        foreach ($receta_archivos as $key => $archivo) {
                            $delete = $ManagerPerfilSaludRecetaArchivo->delete($archivo["idperfilSaludRecetaArchivo"]);
                        }
                    }
                    $delete_estudio = parent::delete($id, true);
                }
            }

            $this->setMsg([ "msg" => "Se han eliminado las recetas seleccionadas", "result" => true]);
            return true;
        }
        $this->setMsg([ "msg" => "Error. No se han podido eliminar las recetas seleccionadas", "result" => false]);
        return false;
    }

    /**
     * Método que envía la receta realizada por un médico a un mail
     * @param array $request
     * @return boolean
     */
    public function enviar_receta($request) {
        if ($request["id"] == "" || $request["email"] == "") {
            $this->setMsg([ "result" => false, "msg" => "Error. Ingrese los campos obligatorios."]);
            return false;
        }


        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $paciente["imagen"] = $this->getManager("ManagerPaciente")->getImagenPaciente($paciente["idpaciente"]);
        //Comienzo a enviar el mail
        $mEmail = $this->getManager("ManagerMail");
        $mEmail->setHTML(true);

        //ojo solo arnet local
        $mEmail->setPort("587");



        $subject = "{$paciente["nombre"]} {$paciente["apellido"]} vous a envoyé un ordonnance";


        $mEmail->setSubject($subject);

        $ManagerPerfilSaludRecetaArchivo = $this->getManager("ManagerPerfilSaludRecetaArchivo");

        $receta = $ManagerPerfilSaludRecetaArchivo->get($request["id"]);

        $smarty = SmartySingleton::getInstance();

        $smarty->assign("paciente", $paciente);
        $smarty->assign("receta", $receta);

        $mEmail->setBody($smarty->Fetch("email/enviar_receta.tpl"));

        $mEmail->addTo($request["email"]);

        if ($mEmail->send()) {

            $this->setMsg(["result" => true, "msg" => "Se ha enviado un mail al médico con la consulta."]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se pudo enviar el mail"]);
            return false;
        }
    }

    /**
     * Metodo que devuleve si una consulta medica posee receta o no
     * @param type $idperfilSaludConsulta
     */
    public function posee_receta($idperfilSaludConsulta) {
        $consulta = $this->getManager("ManagerPerfilSaludConsulta")->get($idperfilSaludConsulta);
        if ($consulta["receta_disponible_consultorio"] == 1) {
            return 1;
        } else {
            $receta = $this->getByField("perfilSaludConsulta_idperfilSaludConsulta", $idperfilSaludConsulta);
            if ($receta) {
                return true;
            }
        }
        return 0;
    }

}

//END_class
?>