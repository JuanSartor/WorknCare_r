<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las condiciones de IVA
 *
 */
class ManagerCondicionIVA extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "condicion_iva", "idcondicion_iva");
        $this->setFlag("active");
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,descripcion");
        $query->setFrom("$this->table");
        $query->setWhere("active=1");
        $query->setOrderBy("descripcion");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>