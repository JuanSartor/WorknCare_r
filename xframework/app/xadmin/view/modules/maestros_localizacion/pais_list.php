<?php
    /**	
	*	Modulo PHP: Listado de paises
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\view\modules\maestros_localizacion
	*
	*/ 
    
    $manager = $this->getManager("ManagerPais");

    $paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());
    
	$this->assign("paginate",$paginate);
	
	
?>