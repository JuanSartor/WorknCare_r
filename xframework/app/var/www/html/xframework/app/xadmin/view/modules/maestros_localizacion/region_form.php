<?php
    /**	
	*	Modulo PHP: Formulario de creacion/edicion de regiones
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/
  
    $ManagerRegion = $this->getManager("ManagerRegion");
    
    if (isset($this->request["id"]) &&  $this->request["id"] > 0){                

		$record = $ManagerRegion->get($this->request["id"]);
		
        
        $this->assign("record",$record);
    }

?>
