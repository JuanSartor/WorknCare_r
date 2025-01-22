<?php

/** 	
 * 	Accion: Grilla del Listado de Cuestionarios
 * 	
 */
$manager = $this->getManager("ManagerCapsula");
$records = $manager->getListadoCapsulaAdmin($this->request, $manager->getDefaultPaginate());

echo $records;
