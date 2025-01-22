<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Programas de salud grupo.
 *
 */
class ManagerModeloRiesgo extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "modelos_riesgo", "idmodelos_riesgos");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {


        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("
                *
            ");
        $query->setFrom("
                $this->table 
            ");

        // Filtro
        if ($request["nombre"] != "") {

            $rdo = cleanQuery($request["nombre"]);

            $query->addAnd("nombre LIKE '%$rdo%'");
        }

        $query->addAnd("idmodelos_riesgos!=1");
        $data = $this->getJSONList($query, array("nombre"), $request, $idpaginate);

        return $data;
    }

    /**
     * Método que devuelve un registro 
     * @param type $id
     */
    public function get($id) {
        $record = parent::get($id);
        return $record;
    }

    public function deleteModelo($ids) {

        $records = explode(",", $ids);
        $manager = $this->getManager("ManagerFamiliaRiesgo");
        $query = new AbstractSql();
        $query->setSelect("t.idfamilia_riesgo");
        $query->setFrom("$manager->table t");
        $query->setWhere("t.modelos_riesgo_idmodelos_riesgo = $ids");
        $listado = $manager->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            /**   foreach ($listado as $id) {

              $manager->deleteFamilia($id["idfamilia_riesgo"]);
              }
             * comente esto porque las familias pueden pertenecer a mas de un modelo
             * 
             */
            return parent::delete($ids);
        }
    }

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id, nombre");
        $query->setFrom("$this->table");
        $query->setWhere("visible=1");
        $query->setOrderBy("idmodelos_riesgos ASC");

        return $this->getComboBox($query, false);
    }

    public function getListadoModelos() {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.visible=1");
        $data = $this->getList($query);
        return $data;
    }

    public function deleteMultiple($ids) {

        $records = explode(",", $ids);
        $managerCuestionario = $this->getManager("ManagerCuestionario");
        $query = new AbstractSql();
        $query->setSelect("t.idcuestionario");
        $query->setFrom("$managerCuestionario->table t");
        $query->setWhere("t.id_familia_cuestionario = $ids");
        $listado = $this->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $managerCuestionario->deleteCuestionario($id["idcuestionario"]);
            }
            return parent::delete($ids);
        }
    }

    /**
     * obtengo la cantidad de los familia riesgos genericos y asociados a la empresa
     * @return type
     */
    public function getFamiliasRiesgoEmpresa() {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $query = new AbstractSql();
        $query->setSelect("count(*) as cantidad, f.nombre,ce.modelos_riesgo_idmodelos_riesgo,f.nombre_en");
        $query->setFrom("familias_riesgo ce
                inner join modelos_riesgo f on (ce.modelos_riesgo_idmodelos_riesgo=f.idmodelos_riesgos)");
        $query->setWhere("ce.empresa_idempresa=0 or ce.empresa_idempresa=" . $idempresa);
        $query->addAnd("ce.visible=1");
        $query->addAnd("f.visible=1");

        $query->setGroupBy("ce.modelos_riesgo_idmodelos_riesgo");
        $list = $this->getList($query);

        $listFinal = Array();
        $it = 0;
        $idsInsertados = Array();
        $posIdIns = 0;
        foreach ($list as $elemento) {
            $ids = explode(",", $elemento["modelos_riesgo_idmodelos_riesgo"]);
            // si esntra en este if es porque esta asociado a mas de una familia

            if (count($ids) > 1) {

                foreach ($ids as $id) {
                    if (in_array($id, $idsInsertados)) {
                        // si esta tengo que sumar la cantidad en 1
                        foreach ($listFinal as $key => $value) {
                            if ($listFinal[$key]["modelos_riesgo_idmodelos_riesgo"] == $id) {
                                $listFinal[$key]["cantidad"] = $listFinal[$key]["cantidad"] + $elemento["cantidad"];
                            }
                        }
                    } else {
                        // si no esta lo agrego
                        $listFinal[$it]["cantidad"] = $elemento["cantidad"];
                        $record = parent::get($id);
                        $listFinal[$it]["nombre"] = $record["nombre"];
                        $listFinal[$it]["nombre_en"] = $record["nombre_en"];
                        $listFinal[$it]["modelos_riesgo_idmodelos_riesgo"] = $id;
                        $idsInsertados[$posIdIns] = $id;
                        $it++;
                        $posIdIns++;
                    }
                }
            } else {

                if (in_array($elemento["modelos_riesgo_idmodelos_riesgo"], $idsInsertados)) {
                    // si esta tengo que sumar la cantidad en 1
                    foreach ($listFinal as $key => $value) {
                        if ($listFinal[$key]["modelos_riesgo_idmodelos_riesgo"] == $elemento["modelos_riesgo_idmodelos_riesgo"]) {
                            $listFinal[$key]["cantidad"] = $listFinal[$key]["cantidad"] + $elemento["cantidad"];
                        }
                    }
                } else {

                    // si no esta lo agrego
                    $listFinal[$it]["cantidad"] = $elemento["cantidad"];
                    $record = parent::get($elemento["modelos_riesgo_idmodelos_riesgo"]);
                    $listFinal[$it]["nombre"] = $record["nombre"];
                    $listFinal[$it]["nombre_en"] = $record["nombre_en"];
                    $listFinal[$it]["modelos_riesgo_idmodelos_riesgo"] = $elemento["modelos_riesgo_idmodelos_riesgo"];
                    $idsInsertados[$posIdIns] = $elemento["modelos_riesgo_idmodelos_riesgo"];
                    $it++;
                    $posIdIns++;
                }
            }
        }


        //  print_r($listFinal);
        return $listFinal;
    }

    public function getCantidadMisModelos() {

        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.empresa_idempresa = " . $idempresa);
        $query->addAnd("t.visible=1");
        return $this->db->GetRow($query->getSql());
    }

    public function getCantidadModelosGenericos() {

        $query = new AbstractSql();
        $query->setSelect("COUNT(*) as cantidad");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.empresa_idempresa =0 ");
        $query->addAnd("t.visible=1");
        return $this->db->GetRow($query->getSql());
    }

    public function getListadoModelosTodos($request) {
        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.visible=1");
        if ($request == '0') {
            $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
            $query->addAnd("t.empresa_idempresa = " . $idempresa);
        } else {
            $query->addAnd("t.empresa_idempresa = 0");
        }

        $data = $this->getList($query);
        return $data;
    }

    /**
     *  crear un modelo cuando eliminan una familia, 
     * es decir lo crea porque ya deja de ser generico
     * @param type $request
     * @return boolean
     */
    public function crearModeloEmpresaConEliminacion($request) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        // creo el modelo asociado a la empresa
        $reModelo["nombre"] = $request["titulo"];
        $reModelo["nombre_en"] = $request["titulo"];
        $reModelo["empresa_idempresa"] = $idempresa;
        $reModelo["descripcion_observacion"] = $request["descripcionModelo"];
        $idModeloNuevo = $this->process($reModelo);
        $rq["idmodeloViejo"] = $request["idmodelos_riesgos"];


        // creo las familas aosciadas al modelo y paso el id de la familia que no debo incluir porque es la eliminada

        if ($idModeloNuevo) {
            $rq["idempresa"] = $idempresa;
            $rq["idmodelo"] = $idModeloNuevo;
            $rq["idFamiliaAEliminar"] = $request["idfamilia_riesgo"];
            $ManagerFam = $this->getManager("ManagerFamiliaRiesgo");

            $ManagerFam->crearFamiliasAsociadasAunModeloEmpresa($rq);
            $this->setMsg(["result" => true, "msg" => "Familia eliminada correctamente.", "idmodelos_riesgos_nuevo" => $idModeloNuevo]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo eliminar la familia, error en creacion de modelo."]);
            return false;
        }
    }

    /**
     *  crear un modelo cuando agregan una familia, 
     * es decir lo crea porque ya deja de ser generico
     * @param type $request
     * @return boolean
     */
    public function crearModeloEmpresaSinEliminacion($request) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        // creo el modelo asociado a la empresa
        $reModelo["nombre"] = $request["nombre"];
        $reModelo["nombre_en"] = $request["nombre"];
        $reModelo["empresa_idempresa"] = $idempresa;
        $reModelo["descripcion_observacion"] = $request["descripcionModelo"];
        $idModeloNuevo = $this->process($reModelo);
        $rq["idmodeloViejo"] = $request["idmodelos_riesgos"];


        // creo las familas aosciadas al modelo y paso el id de la familia que no debo incluir porque es la eliminada

        if ($idModeloNuevo) {
            $rq["idempresa"] = $idempresa;
            $rq["idmodelo"] = $idModeloNuevo;
            $rq["tituloNuevo"] = $request["titulo"];
            $ManagerFam = $this->getManager("ManagerFamiliaRiesgo");

            $ManagerFam->crearFamiliasAsociadasAModeloEmpresaSinEliminar($rq);
            $this->setMsg(["result" => true, "msg" => "Familia agregada correctamente.", "idmodelos_riesgos_nuevo" => $idModeloNuevo]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo eliminar la familia, error en creacion de modelo."]);
            return false;
        }
    }

    /**
     *  crear un modelo cuando actualiza una familia, 
     * es decir lo crea porque ya deja de ser generico
     * @param type $request
     * @return boolean
     */
    public function crearModeloEmpresaConActualizacionFamilia($request) {
        $idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

        // creo el modelo asociado a la empresa
        $reModelo["nombre"] = $request["tituloModelo"];
        $reModelo["nombre_en"] = $request["tituloModelo"];
        $reModelo["empresa_idempresa"] = $idempresa;
        $reModelo["descripcion_observacion"] = $request["descripcionModelo"];
        $idModeloNuevo = $this->process($reModelo);
        $rq["idmodeloViejo"] = $request["idmodelos_riesgos"];


        // creo las familas aosciadas al modelo y paso el id de la familia que no debo incluir porque es la eliminada

        if ($idModeloNuevo) {
            $rq["idempresa"] = $idempresa;
            $rq["idmodelo"] = $idModeloNuevo;
            $rq["tituloNuevo"] = $request["titulo"];
            $rq["idFamiliaEditada"] = $request["idfamilia_riesgo"];
            $ManagerFam = $this->getManager("ManagerFamiliaRiesgo");

            $ManagerFam->crearFamiliasAsociadasAModeloEmpresaConActualizacion($rq);
            $this->setMsg(["result" => true, "msg" => "Familia actualizada correctamente.", "idmodelos_riesgos_nuevo" => $idModeloNuevo]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo actualizar la familia."]);
            return false;
        }
    }

    public function actualizarModeloYFamiliaYaAsociada($request) {

        $reAcMod["nombre"] = $request["tituloModelo"];
        $reAcMod["nombre_en"] = $request["tituloModelo"];
        $reAcMod["descripcion_observacion"] = $request["descripcionModelo"];
        $this->update($reAcMod, $request["idmodelos_riesgos"]);

        $managerFam = $this->getManager("ManagerFamiliaRiesgo");
        $reAcF["titulo"] = $request["titulo"];
        $reAcF["titulo_en"] = $request["titulo"];
        $rdo = $managerFam->update($reAcF, $request["idfamilia_riesgo"]);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Familia actualizada correctamente.", "idmodelos_riesgos_nuevo" => $request["idmodelos_riesgos"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo actualizar la familia."]);
            return false;
        }
    }

}

//END_class
?>

