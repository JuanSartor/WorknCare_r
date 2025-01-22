<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Programas de salud grupo.
 *
 */
class ManagerFamiliaCapsula extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "familia_capsulas", "id_familia_capsula");
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

    public function getCombo() {
        $query = new AbstractSql();
        $query->setSelect("$this->id, nombre");
        $query->setFrom("$this->table");
        $query->setWhere("visible=1");
        $query->addAnd("id_familia_capsula!=1");
        $query->setOrderBy("id_familia_capsula ASC");

        return $this->getComboBox($query, false);
    }

    public function deleteMultipleFamiliasCapsulas($ids) {

        $records = explode(",", $ids);
        $managerContemedor = $this->getManager("ManagerContenedorCapsula");
        $query = new AbstractSql();
        $query->setSelect("t.idcontenedorcapsula");
        $query->setFrom("$managerContemedor->table t");
        $query->setWhere("t.familia_capsula_id_familia_capsula = $ids");
        $listado = $this->getList($query);

        if (count($records) != 1) {

            $this->setMsg(["result" => false, "msg" => "Debe seleccionar un registro, no mas de uno."]);
            return false;
        } else {

            foreach ($listado as $id) {

                $managerContemedor->deleteContenedor($id["idcontenedorcapsula"]);
            }
            return parent::delete($ids);
        }
    }

}

//END_class
?>

