<?php
    /**	
	*	Accion: Alta/Modificacion de localidad
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $this->start();        
    $manager = $this->getManager("ManagerLocalidad");
    $result = $manager->process($this->request);            
	$this->finish($manager->getMsg()); 
	
?>
