<?php
    /**	
	*	Accion: Grilla del listado de Paises
	*
	*	@author UTN
	*	@version 1.0
	*	@package app\actions\maestros_localizacion
	*
	*/

    $manager = $this->getManager("ManagerPais");
 
	$records = $manager->getListadoJSON($manager->getDefaultPaginate(),$this->request);	
	 
    echo $records;
    
	
?>
