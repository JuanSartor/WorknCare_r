<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de los packs de SMS del Médico
 *
 */
class ManagerTraduccionTemp extends Manager {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "traduccion_temp", "id");
      
    }

  

}

//END_class
?>