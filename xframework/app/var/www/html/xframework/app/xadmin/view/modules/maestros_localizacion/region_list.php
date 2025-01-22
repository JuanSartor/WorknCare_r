<?php
    /**	
	*	Modulo PHP: Listado de regiones
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/ 

    $manager = $this->getManager("ManagerRegion");	

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	
	
?>
