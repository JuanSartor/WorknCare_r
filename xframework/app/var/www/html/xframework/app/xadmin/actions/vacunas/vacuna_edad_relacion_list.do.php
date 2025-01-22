<?php

/** 	
 * 	Accion: Grilla del Listado de las vacunas
 */
$manager = $this->getManager("ManagerVacunaVacunaEdad");
//$manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
