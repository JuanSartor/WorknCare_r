<?php
	/**	
	*	Accion: Eliminacion mutiple de localidades
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/ 

    $manager = $this->getManager("ManagerLocalidad");
	
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
