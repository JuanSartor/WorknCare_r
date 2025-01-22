<?php
    /**	
	*	Accion: Grilla del listado de Provincias
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $manager = $this->getManager("ManagerProvincia");
 
	$records = $manager->getListadoJSON($manager->getDefaultPaginate(),$this->request);	
	 
    echo $records;
    
	
?>
