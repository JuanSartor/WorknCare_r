<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	22/02/2021
 * 	Manager de paises pago SEPA
 *
 */
class ManagerPaisSepa extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "pais_sepa", "idpais_sepa");
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,pais_sepa");
        $query->setFrom("$this->table");
        $query->setOrderBy("pais_sepa asc");
        return $this->getComboBox($query, false);
    }

}

//END_class
?>