<?php

/** 	
 * 	Accion: Grilla del Listado de los embajadores
 * 	
 */
$manager = $this->getManager("ManagerEmbajador");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
