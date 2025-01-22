<?php
    /**	
	*	Accion: Obtiene el CPA de una localidad
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $this->start();        
    $manager = $this->getManager("ManagerLocalidad");
    $localidad = $manager->get($this->request["idlocalidad"]);            
	$this->finish($localidad); 
	
?>
