<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Las Obras Sociales - Prepagas
 *
 */
class ManagerIdiomas extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "idioma", "ididioma");
    }

    
    public function getCombo() {

        $query = new AbstractSql();
        $query->setSelect("$this->id,idioma");
        $query->setFrom("$this->table");
        
        return $this->getComboBox($query, false);
    }
    

}

//END_class
?>