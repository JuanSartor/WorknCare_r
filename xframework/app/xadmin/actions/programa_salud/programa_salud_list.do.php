<?php

/** 	
 * 	Accion: Grilla del Listado de Programas de salud
 * 	
 */
$manager = $this->getManager("ManagerProgramaSalud");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
