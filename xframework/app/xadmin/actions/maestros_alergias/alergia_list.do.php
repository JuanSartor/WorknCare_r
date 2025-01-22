<?php

/** 	
 * 	Accion: Grilla del Listado de las especialidades
 * 	
 */
$manager = $this->getManager("ManagerTipoAlergia");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
