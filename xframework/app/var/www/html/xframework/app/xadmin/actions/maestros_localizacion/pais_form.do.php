<?php
    /**	
	*	Accion: Alta/Modificacion de País
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $this->start();        
    $manager = $this->getManager("ManagerPais");
    $result = $manager->process($this->request);            
	$this->finish($manager->getMsg()); 
	
?>
