<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de las vacunas edad
 *
 */
class ManagerUnidadTemporal extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "unidadTemporal", "idunidadTemporal");
        
    }


    /**
     * ComboBox de vacunas
     * @return type
     */
    public function getCombo() {

        $query = new AbstractSql();
        
        $query->setSelect("$this->id, unidadTemporal");
        
        $query->setFrom("$this->table");
                
        return $this->getComboBox($query, false);
    }
    

}

//END_class
?>