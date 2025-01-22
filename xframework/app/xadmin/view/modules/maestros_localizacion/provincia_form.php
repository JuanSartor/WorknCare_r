<?php
    /**	
	*	Modulo PHP: Formulario de creacion/edicion de provincias
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/
  
    $managerP = $this->getManager("ManagerPais");
    $manager = $this->getManager("ManagerProvincia");	
    
    if (isset($this->request["id"]) &&  $this->request["id"] > 0){                

		$record = $manager->get($this->request["id"]);
		
        
        $this->assign("record",$record);
    }


	$this->assign("paises",$managerP->getCombo());	
    
    $this->assign("combo_region",$this->getManager("ManagerRegion")->getCombo());
    
           
?>
