<?php
    /**	
	*	Accion: Grilla del listado de Locaidades
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $manager = $this->getManager("ManagerLocalidad");
 //$manager->debug();
	$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());	
	 
    echo $records;
    
	
?>
