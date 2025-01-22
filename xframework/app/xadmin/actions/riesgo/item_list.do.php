<?php

/** 	
 * 	Accion: Grilla del Listado de Cuestionarios
 * 	
 */
$manager = $this->getManager("ManagerItemRiesgo");

$records1 = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records1;



