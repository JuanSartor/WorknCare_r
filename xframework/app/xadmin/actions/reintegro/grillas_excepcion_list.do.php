<?php

/** 	
 * 	Accion: Grilla de las excepciones de las grillas cargadas en el sistema
 * 	
 */
$manager = $this->getManager("ManagerGrillaExcepcion");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
