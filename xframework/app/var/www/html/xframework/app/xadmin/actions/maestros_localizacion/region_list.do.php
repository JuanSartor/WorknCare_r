<?php
    /**	
	*	Accion: Grilla del listado de Regiones
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $manager = $this->getManager("ManagerRegion");
 
	$records = $manager->getListadoJSON($manager->getDefaultPaginate(),$this->request);	
	 
    echo $records;
    
	
?>
