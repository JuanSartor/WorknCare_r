<?php

/** 	
 * 	Accion: Grilla de los planes de prestadores cargados en el sistema    
 * 	
 */
$manager = $this->getManager("ManagerPlanPrestador");

$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
?>
