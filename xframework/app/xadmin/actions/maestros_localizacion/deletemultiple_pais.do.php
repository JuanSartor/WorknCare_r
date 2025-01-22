<?php
	/**	
	*	Accion: Eliminacion mutiple de Pais
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/   

    $manager = $this->getManager("ManagerPais");
	
    $manager->deleteMultiple($this->request['ids'], false);    
    
    $this->finish($manager->getMsg());

?>
