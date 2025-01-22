<?php
	/**	
	*	Accion: Eliminacion mutiple de Provincia
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/ 

    $manager = $this->getManager("ManagerRegion");
	
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
