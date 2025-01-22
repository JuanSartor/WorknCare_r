<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Programas de salud.
 *
 */
class ManagerItemRiesgo extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "item_riesgo", "idItemRiesgo");
    }

    public function getListadoJSON($request, $idpaginate = NULL) {

        if (!is_null($idpaginate)) {
            $this->paginate($idpaginate, 20);
        }

        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom("$this->table  t  INNER JOIN familias_riesgo f ON (f.idfamilia_riesgo = t.familia_riesgo_idfamiliariesgo)");
        $query->setWhere("empresa_idempresa = 0");
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

    public function deleteItem($ids) {

        $records = explode(",", $ids);
        $manager = $this->getManager("ManagerItemCheckRiesgo");
        $query = new AbstractSql();
        $query->setSelect("t.id_check_itemriesgo");
        $query->setFrom("$manager->table t");
        $query->setWhere("t.item_riesgo_iditemriesgo = $ids");
        $listado = $manager->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $manager->delete($id["id_check_itemriesgo"]);
            }
            return parent::delete($ids);
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
        $query->setWhere("t.modelos_riesgo_idmodelos_riesgo=" . $request["idmodelos_riesgos"]);
        $query->setOrderBy("t.idfamilia_riesgo DESC");
        $data = $this->getList($query);
        return $data;
    }

    public function getListadoItems($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.familia_riesgo_idfamiliariesgo=" . $request["familia_riesgo_idfamiliariesgo"]);
        $query->setOrderBy("t.idItemRiesgo ASC");
        $query->addAnd("t.visible=1");
        return $this->getList($query);
    }

    /**
     *  creo los items asociados perteneciente a la familia pasada como parametro y los asocio a la nueva familia pasada como parametro
     * @param type $request
     */
    public function crearItemsAsociadosAunaFamiliaEmpresa($request) {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idUsuarioEmpresa);

        $items = $this->getListadoItems(["familia_riesgo_idfamiliariesgo" => $request["idfamiliaGenericaInicial"]]);
        $renewitem["familia_riesgo_idfamiliariesgo"] = $request["idfamiliaEmpresaFinal"];


        $managerCheckItem = $this->getManager("ManagerItemCheckRiesgo");

        foreach ($items as $item) {
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $renewitem["titulo"] = $item["titulo"];
                $renewitem["titulo_en"] = $item["titulo"];
                $renewitem["descripcion"] = $item["descripcion"];
                $renewitem["descripcion_en"] = $item["descripcion"];
                $renewitem["pregunta"] = $item["pregunta"];
                $renewitem["pregunta_en"] = $item["pregunta"];
            } else {
                $renewitem["titulo"] = $item["titulo_en"];
                $renewitem["titulo_en"] = $item["titulo_en"];
                $renewitem["descripcion"] = $item["descripcion_en"];
                $renewitem["descripcion_en"] = $item["descripcion_en"];
                $renewitem["pregunta"] = $item["pregunta_en"];
                $renewitem["pregunta_en"] = $item["pregunta_en"];
            }

            $idItemnuevo = $this->process($renewitem);
//            if ($idItemnuevo) {
            $reChkItem["iditemGenericaInicial"] = $item["idItemRiesgo"];
            $reChkItem["iditemEmpresaFinal"] = $idItemnuevo;
            $managerCheckItem->crearCheckAsociadosAunaItemEmpresa($reChkItem);
//            } else {
//                $this->setMsg(["result" => false, "msg" => "Error al crear el item."]);
//                return false;
//            }
        }
    }

}

//END_class
?>