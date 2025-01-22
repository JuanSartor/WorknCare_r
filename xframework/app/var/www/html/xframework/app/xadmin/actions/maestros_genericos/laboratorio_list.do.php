<?php

/** 	
 * 	Accion: Grilla del Listado de los laboratorios
 * 	
 */
$manager = $this->getManager("ManagerLaboratorio");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
