<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	20/11/2020
 * 	Manager de Programas de salud.
 *
 */
class ManagerItemCheckRiesgo extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "check_itemriesgo", "id_check_itemriesgo");
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

    public function process($request) {

        return parent::process($request);
    }

    public function getListadoItemsCheck($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.item_riesgo_iditemriesgo=" . $request["item_riesgo_iditemriesgo"]);
        $query->setOrderBy("t.id_check_itemriesgo ASC");
        return $this->getList($query);
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

    /**
     *  creo los check asociados a el item pasado como parametro pero lo asocio a el nuevo item que pertenece a una empresa logueada
     * @param type $request
     */
    public function crearCheckAsociadosAunaItemEmpresa($request) {
        $idUsuarioEmpresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($idUsuarioEmpresa);

        $checks = $this->getListadoItemsCheck(["item_riesgo_iditemriesgo" => $request["iditemGenericaInicial"]]);
        $renewcheck["item_riesgo_iditemriesgo"] = $request["iditemEmpresaFinal"];

        foreach ($checks as $check) {
            if ($usuario_empresa["idioma_predeterminado"] == 'fr') {
                $renewcheck["texto"] = $check["texto"];
                $renewcheck["texto_en"] = $check["texto_"];
            } else {
                $renewcheck["texto"] = $check["texto_en"];
                $renewcheck["texto_en"] = $check["texto_en"];
            }

            $rdo = $this->process($renewcheck);

//            if (!$rdo) {
//                $this->setMsg(["result" => false, "msg" => "Error al crear el item check."]);
//                return false;
//            }
        }
    }

}

//END_class
?>