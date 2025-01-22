<?php

/** 	
 * 	Accion: Grilla del Listado de Familia de cuestionarios
 * 	
 */
$manager = $this->getManager("ManagerModeloRiesgo");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());
echo $records;
