<?php

/** 	
 * 	Accion: Grilla de los médicos cargados en el sistema
 * 	
 */
$manager = $this->getManager("ManagerMedico");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
?>
