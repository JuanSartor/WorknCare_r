<?php

/** 	
 * 	Accion: Grilla de los médicos cargados en el sistema
 * 	
 */
$manager = $this->getManager("ManagerPaciente");
// $manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
