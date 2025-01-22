<?php

/**
 * @autor Juan
 * 
 * Class ManagerHistorialExBeneficiarios
 * 	
 * 
 */
class ManagerHistorialExBeneficiarios extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "historial_exbeneficiarios", "idhistorialbeneficiarios");
        $this->default_paginate = "historial_exbeneficiarios";
    }

}

//END_class 
?>