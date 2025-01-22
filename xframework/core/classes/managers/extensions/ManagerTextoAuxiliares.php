<?php

/**
 * 	@autor Juan Sartor
 * 	@version 	01/10/2021
 * 	Manager de Programas de salud grupo.
 *
 */
class ManagerTextoAuxiliares extends ManagerMaestros {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "textoaxuliares", "idtextoauxiliar");
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
        if ($request["texto_fr"] != "") {

            $rdo = cleanQuery($request["texto_fr"]);

            $query->addAnd("texto_fr LIKE '%$rdo%'");
        }


        $data = $this->getJSONList($query, array("texto_fr", "texto_en", "descripcion"), $request, $idpaginate);

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

}

//END_class
?>

