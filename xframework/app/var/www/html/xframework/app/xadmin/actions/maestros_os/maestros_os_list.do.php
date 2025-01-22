<?php

/** 	
 * 	Accion: Grilla del Listado de Obras Sociales - Prepagas
 * 	
 */
$manager = $this->getManager("ManagerObrasSociales");
//$manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
