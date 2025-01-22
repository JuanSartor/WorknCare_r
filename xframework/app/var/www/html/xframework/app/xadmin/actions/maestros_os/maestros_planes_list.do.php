<?php

/** 	
 * 	Accion: Grilla del Listado de los planes de las Obras Sociales - Prepagas
 * 	
 */
$manager = $this->getManager("ManagerPlanesObrasSociales");
//$manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
