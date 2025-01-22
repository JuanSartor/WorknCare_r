<?php
    /**	
	*	Modulo PHP: Listado de provincias
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/ 
    
    $managerP = $this->getManager("ManagerPais");
    $manager = $this->getManager("ManagerProvincia");	

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	$this->assign("paises",$managerP->getCombo());	
	
	
?>
