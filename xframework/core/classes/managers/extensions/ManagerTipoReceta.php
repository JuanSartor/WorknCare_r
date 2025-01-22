<?php

/**
 * 	@autor Xinergia
 * 	Manager de los tipos de receta
 *
 */
class ManagerTipoReceta extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "tipo_receta", "idtipo_receta");

        $this->default_paginate = "tipo_receta_list";
    }

   


  

    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,tipo_receta");
        $query->setFrom("$this->table");

        return $this->getComboBox($query, false);
    }

}

//END_class
?>