<?php

/** 	
 * 	Accion: Grilla del Listado de los planes de las Subespecialidades
 * 	
 */
$manager = $this->getManager("ManagerSubTipoAlergia");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
