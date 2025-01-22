<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Programas de salud grupo.
 *
 */
class ManagerContenedorCapsula extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "contenedor_capsula", "idcontenedorcapsula");
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
        if ($request["titulo"] != "") {

            $rdo = cleanQuery($request["nombre"]);

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

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id, titulo");
        $query->setFrom("$this->table");
        $query->setWhere("visible=1");
        $query->setOrderBy("idcontenedorcapsula ASC");

        return $this->getComboBox($query, false);
    }

    public function deleteContenedor($ids) {


        $records = explode(",", $ids);

        $managerCuestionario = $this->getManager("ManagerCapsula");
        $query = new AbstractSql();
        $query->setSelect("t.idcapsula");
        $query->setFrom("$managerCuestionario->table t");
        $query->setWhere("t.contenedorcapsula_idcontenedorcapsula = $ids");
        $listado = $this->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $managerCuestionario->deleteMultiple($id["idcapsula"]);
            }
            return parent::delete($ids);
        }
    }

    public function getListadoContenedores($request, $idpaginate = null) {
        $query = new AbstractSql();
        $query->setSelect("t.*");
        $query->setFrom(" $this->table  t");
        $query->setWhere("t.familia_capsula_id_familia_capsula=" . $request["id_familia_capsula"]);
        $query->setOrderBy("t.orden DESC");
        $query->addAnd("t.visible=1");
        $data = $this->getList($query);

        return $data;
    }

}

//END_class
?>

