<?php

/** 	
 * 	Accion: Grilla de las grillas cargados en el sistema
 * 	
 */
$manager = $this->getManager("ManagerGrilla");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
