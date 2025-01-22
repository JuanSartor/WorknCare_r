<?php

/** 	
 * 	Accion: Grilla del Listado de los bancos
 * 	
 */
$manager = $this->getManager("ManagerBanco");

$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;

