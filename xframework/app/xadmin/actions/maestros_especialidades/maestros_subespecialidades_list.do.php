<?php

/** 	
 * 	Accion: Grilla del Listado de los planes de las Subespecialidades
 * 	
 */
$manager = $this->getManager("ManagerSubEspecialidades");
//$manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
