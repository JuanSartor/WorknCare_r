<?php

/** 	
 * 	Accion: Grilla del Listado de las especialidades
 * 	
 */
$manager = $this->getManager("ManagerEspecialidades");
//$manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
