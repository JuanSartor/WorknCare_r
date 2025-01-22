<?php

/** 	
 * 	Accion: Grilla del Listado de los cupones
 * 	
 */
$manager = $this->getManager("ManagerProgramaSaludCupon");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
