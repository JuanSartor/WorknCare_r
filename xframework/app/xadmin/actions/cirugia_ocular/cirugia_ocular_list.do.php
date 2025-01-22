<?php

/** 	
 * 	Accion: Grilla del Listado de las cirugias oculares
 */
$manager = $this->getManager("ManagerCirugiaOcular");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
