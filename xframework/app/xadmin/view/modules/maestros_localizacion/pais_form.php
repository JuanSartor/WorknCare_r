<?php
    /**	
	*	Modulo PHP: Formulario de creacion/edicion de paises
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/
  
    $manager = $this->getManager("ManagerPais");
    
    if (isset($this->request["id"]) &&  $this->request["id"] > 0){                

		$record = $manager->get($this->request["id"]);
		
        
        $this->assign("record",$record);
    }
           
?>
