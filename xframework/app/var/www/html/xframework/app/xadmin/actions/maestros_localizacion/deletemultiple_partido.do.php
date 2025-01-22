<?php
	/**	
	*	Accion: Eliminacion mutiple de Partido
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/  

    $manager = $this->getManager("ManagerPartido");
	
    $manager->deleteMultiple($this->request['ids'], true);    
    
    $this->finish($manager->getMsg());

?>
