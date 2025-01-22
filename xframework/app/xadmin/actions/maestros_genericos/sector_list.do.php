<?php

/** 	
 * 	Accion: Grilla del Listado de los sectores
 * 	
 */
$manager = $this->getManager("ManagerSector");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
