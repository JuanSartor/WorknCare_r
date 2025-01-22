<?php
    /**	
	*	Accion: Grilla del listado de Partidos	
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $manager = $this->getManager("ManagerPartido");
 
	$records = $manager->getListadoJSON($manager->getDefaultPaginate(),$this->request);	
	 
    echo $records;
    
	
?>
