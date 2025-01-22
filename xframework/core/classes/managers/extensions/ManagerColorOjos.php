<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las condiciones de Color de OJOs
 *
 */
class ManagerColorOjos extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "colorojos", "idcolorOjos");
        $this->setFlag("active");
    }

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,colorOjos");
        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>