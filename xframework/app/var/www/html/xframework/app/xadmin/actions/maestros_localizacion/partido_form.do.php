<?php
    /**	
	*	Accion: Alta/Modificacion de Partido
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/
    $this->start();        
    $manager = $this->getManager("ManagerPartido");
    $result = $manager->process($this->request);            
	$this->finish($manager->getMsg()); 
	
?>
