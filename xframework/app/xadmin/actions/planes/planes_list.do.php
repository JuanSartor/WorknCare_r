<?php

/** 	
 * 	Accion: Grilla del Listado de los planes
 * 	
 */
$manager = $this->getManager("ManagerProgramaSaludPlan");
//$manager->debug();
$records = $manager->getListadoJSONTexto($this->request, $manager->getDefaultPaginate());


echo $records;
?>
