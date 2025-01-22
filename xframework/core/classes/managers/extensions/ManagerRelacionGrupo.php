<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Relación Grupo
 *
 */
class ManagerRelacionGrupo extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "relaciongrupo", "idrelacionGrupo");
    }

    public function getCombo() {

        $query = new AbstractSql();

        $query->setSelect("$this->id, CONCAT(label,' ', relacionGrupo)");

        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

    public function getComboInversa() {

        $query = new AbstractSql();

        $query->setSelect("$this->id, CONCAT(UCASE(LEFT(relacionInversa, 1)), LCASE(SUBSTRING(relacionInversa, 2)))");

        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>