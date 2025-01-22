<?php

/** 	
 * 	Accion: Grilla de los médicos registrados desde el frontend y que no han completado el registro
 * 	
 */
$manager = $this->getManager("ManagerPreregistro");
//$manager->debug();
$records = $manager->getListadoPreregistroJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
