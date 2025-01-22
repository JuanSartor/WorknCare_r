<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Programas de salud.
 *
 */
class ManagerFamiliaRiesgo extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "familias_riesgo", "idfamilia_riesgo");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("*");
        $query->setFrom("
                $this->table 
            ");
        $query->setWhere("empresa_idempresa=0");
        // Filtro
        if ($request["titulo"] != "") {

            $rdo = cleanQuery($request["titulo"]);

            $query->addAnd("titulo LIKE '%$rdo%'");
        }
        $data = $this->getJSONList($query, array("titulo"), $request, $idpaginate);

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

    public function desasociarModelo($request) {
        $record = parent::get($request["idfamilia_riesgo"]);
        $part = explode(",", $record["modelos_riesgo_idmodelos_riesgo"]);
        $cadFinal = '';
        foreach ($part as $id) {
            if ($id != $request["idmodelo"]) {
                $cadFinal = $id . "," . $cadFinal;
            }
        }
        $re["modelos_riesgo_idmodelos_riesgo"] = substr($cadFinal, 0, -1);
        return parent::update($re, $request["idfamilia_riesgo"]);
    }

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id, titulo");
        $query->setFrom("$this->table");
        $query->setWhere("visible=1");
        $query->setOrderBy("idfamilia_riesgo ASC");

        return $this->getComboBox($query, false);
    }

    public function deleteFamilia($ids) {

        $records = explode(",", $ids);
        $manager = $this->getManager("ManagerItemRiesgo");
        $query = new AbstractSql();
        $query->setSelect("t.idItemRiesgo");
        $query->setFrom("$manager->table t");
        $query->setWhere("t.familia_riesgo_idfamiliariesgo = $ids");
        $listado = $manager->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $manager->deleteItem($id["idItemRiesgo"]);
            }
            return parent::delete($ids);
        }
    }

    public function deleteFamiliaAsociadaAModelo($ids, $idmodelo) {

        $records = explode(",", $ids);
        $manager = $this->getManager("ManagerItemRiesgo");
        $query = new AbstractSql();
        $query->setSelect("t.idItemRiesgo");
        $query->setFrom("$manager->table t");
        $query->setWhere("t.familia_riesgo_idfamiliariesgo = $ids");
        $listado = $manager->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $manager->deleteItem($id["idItemRiesgo"]);
            }
            $rdo = parent::delete($ids);
            if ($rdo) {

                $this->setMsg(["result" => true, "msg" => "Familia eliminada correctamente.", "idmodelos_riesgos_nuevo" => $idmodelo]);
                return true;
            } else {
                $this->setMsg(["result" => false, "msg" => "No se pudo eliminar la familia, error en creacion de modelo."]);
                return false;
            }
        }
    }

    /**
     * 
     *  obtengo listado de cuestionarios todos los de la familia pasada
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoFamilias($request, $idpaginate = null) {

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.empresa_idempresa=0");
        $query->addAnd("t.visible=1");
        $list = $this->getList($query);

        $listReturn = array();
        $i = 0;
        foreach ($list as $elemento) {
            $ids = explode(",", $elemento["modelos_riesgo_idmodelos_riesgo"]);
            if (in_array($request["idmodelos_riesgos"], $ids)) {
                $listReturn[$i] = $elemento;
                $i++;
            }
        }

        return $listReturn;
    }

    public function getListadoFamiliasPorModelo($request) {

        $ManagerModelo = $this->getManager("ManagerModeloRiesgo");
        $modelo = $ManagerModelo->get($request["modelos_riesgo_idmodelos_riesgo"]);



        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        if ($modelo["empresa_idempresa"] == '0') {
            $query->setWhere("t.empresa_idempresa=0");
        } else {
            $query->setWhere("t.empresa_idempresa=" . $modelo["empresa_idempresa"]);
        }
        $query->addAnd("t.visible=1");
        $list = $this->getList($query);

        $listReturn = array();
        $i = 0;
        foreach ($list as $elemento) {

            $ids = explode(",", $elemento["modelos_riesgo_idmodelos_riesgo"]);
            if (count($ids) > 1) {
                if (in_array($request["modelos_riesgo_idmodelos_riesgo"], $ids)) {
                    $listReturn[$i] = $elemento;
                    $i++;
                }
            } else {
                if ($elemento["modelos_riesgo_idmodelos_riesgo"] == $request["modelos_riesgo_idmodelos_riesgo"]) {
                    $listReturn[$i] = $elemento;
                    $i++;
                }
            }
        }
        return $listReturn;
    }

    /**
     *
     * obtengo listado de familias de riesgo asociadas al modelo
     * @param type $request
     * @param type $idpaginate
     * @return type
     */
    public function getListadoFamiliasRiesgo($request, $idpaginate = null) {


        // obtengo todos los modelos de la fimilia y selecciono los id de las familias que coinciden con id pasado como request
        $queryM = new AbstractSql();
        $queryM->setSelect("t.*");
        $queryM->setFrom(" $this->table  t");
        $queryM->setWhere("t.visible=1");
        $listModelos = $this->getList($queryM);
        $idsFamilia = Array();
        $pos = 0;

        foreach ($listModelos as $elemento) {
            $arrIdMo = explode(",", $elemento["modelos_riesgo_idmodelos_riesgo"]);
            if (count($arrIdMo) > 1) {
                foreach ($arrIdMo as $idM) {
                    if ($idM == $request["modelos_riesgo_idmodelos_riesgo"]) {
                        $idsFamilia[$pos] = $elemento["idfamilia_riesgo"];
                        $pos ++;
                    }
                }
            } else {
                if ($elemento["modelos_riesgo_idmodelos_riesgo"] == $request["modelos_riesgo_idmodelos_riesgo"]) {
                    $idsFamilia[$pos] = $elemento["idfamilia_riesgo"];
                    $pos ++;
                }
            }
        }

        $lisResult = Array();
        $posR = 0;
        foreach ($idsFamilia as $idF) {
            $lisResult[$posR] = $this->get($idF);
            $posR ++;
        }



        return $lisResult;
    }

    /**
     *  crea las familias asociadas al modelo pasado como parametro y asociados a la empresa logueada
     * @param type $request
     */
    public function crearFamiliasAsociadasAunModeloEmpresa($request) {

        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idUsuarioEmpresa);

        $listFamilias = $this->getListadoFamiliasRiesgo($request["idmodeloViejo"]);

        $managerItem = $this->getManager("ManagerItemRiesgo");

        foreach ($listFamilias as $fam) {
            // creo todas las familias menos la que elimino
            if ($fam["idfamilia_riesgo"] != $request["idFamiliaAEliminar"]) {
                $rqF["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelo"];

                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $rqF["titulo"] = $fam["titulo"];
                    $rqF["titulo_en"] = $fam["titulo"];
                } else {
                    $rqF["titulo"] = $fam["titulo_en"];
                    $rqF["titulo_en"] = $fam["titulo_en"];
                }

                $rqF["empresa_idempresa"] = $request["idempresa"];
                $idF = $this->process($rqF);

//                if ($idF) {
                $reItem["idfamiliaGenericaInicial"] = $fam["idfamilia_riesgo"];
                $reItem["idfamiliaEmpresaFinal"] = $idF;
                $managerItem->crearItemsAsociadosAunaFamiliaEmpresa($reItem);

//                } else {
//                    $this->setMsg(["result" => false, "msg" => "Error al crear la familia de riesgo."]);
//                    return false;
//                }
            }
        }
    }

    public function crearFamiliasAsociadasAModeloEmpresaSinEliminar($request) {

        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idUsuarioEmpresa);

        $listFamilias = $this->getListadoFamiliasRiesgo($request["idmodeloViejo"]);

        $managerItem = $this->getManager("ManagerItemRiesgo");

        foreach ($listFamilias as $fam) {
            // creo todas las familias 

            $rqF["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelo"];

            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $rqF["titulo"] = $fam["titulo"];
                $rqF["titulo_en"] = $fam["titulo"];
            } else {
                $rqF["titulo"] = $fam["titulo_en"];
                $rqF["titulo_en"] = $fam["titulo_en"];
            }

            $rqF["empresa_idempresa"] = $request["idempresa"];
            $idF = $this->process($rqF);


            $reItem["idfamiliaGenericaInicial"] = $fam["idfamilia_riesgo"];
            $reItem["idfamiliaEmpresaFinal"] = $idF;
            $managerItem->crearItemsAsociadosAunaFamiliaEmpresa($reItem);
        }
        $reAdd["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelo"];
        $reAdd["empresa_idempresa"] = $request["idempresa"];

        $reAdd["titulo"] = $request["tituloNuevo"];
        $reAdd["titulo_en"] = $request["tituloNuevo"];
        $this->process($reAdd);
    }

    public function insertarFamilia($request) {
        $reIns["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelos_riesgos"];
        $reIns["empresa_idempresa"] = $request["idempresa"];
        $reIns["titulo"] = $request["titulo"];
        $reIns["titulo_en"] = $request["titulo"];
        $rdo = $this->process($reIns);
        if ($rdo) {
            $this->setMsg(["result" => true, "msg" => "Familia agregada correctamente.", "idmodelos_riesgos_nuevo" => $request["idmodelos_riesgos"]]);
            return true;
        } else {
            $this->setMsg(["result" => false, "msg" => "No se pudo agregar la familia."]);
            return false;
        }
    }

    public function crearFamiliasAsociadasAModeloEmpresaConActualizacion($request) {

        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idUsuarioEmpresa);

        $listFamilias = $this->getListadoFamiliasRiesgo($request["idmodeloViejo"]);

        $managerItem = $this->getManager("ManagerItemRiesgo");

        foreach ($listFamilias as $fam) {
            // creo todas las familias 

            if ($fam["idfamilia_riesgo"] == $request["idFamiliaEditada"]) {
                $rqF["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelo"];
                $rqF["titulo"] = $request["tituloNuevo"];
                $rqF["titulo_en"] = $request["tituloNuevo"];

                $rqF["empresa_idempresa"] = $request["idempresa"];
                $idF = $this->process($rqF);

                $reItem["idfamiliaGenericaInicial"] = $fam["idfamilia_riesgo"];
                $reItem["idfamiliaEmpresaFinal"] = $idF;
                $managerItem->crearItemsAsociadosAunaFamiliaEmpresa($reItem);
            } else {
                $rqF["modelos_riesgo_idmodelos_riesgo"] = $request["idmodelo"];

                if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                    $rqF["titulo"] = $fam["titulo"];
                    $rqF["titulo_en"] = $fam["titulo"];
                } else {
                    $rqF["titulo"] = $fam["titulo_en"];
                    $rqF["titulo_en"] = $fam["titulo_en"];
                }

                $rqF["empresa_idempresa"] = $request["idempresa"];
                $idF = $this->process($rqF);


                $reItem["idfamiliaGenericaInicial"] = $fam["idfamilia_riesgo"];
                $reItem["idfamiliaEmpresaFinal"] = $idF;
                $managerItem->crearItemsAsociadosAunaFamiliaEmpresa($reItem);
            }
        }
    }

}

//END_class
?>