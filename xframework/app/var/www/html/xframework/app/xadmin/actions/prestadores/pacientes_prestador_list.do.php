<?php

/** 	
 * 	Accion: Grilla de los prestadores cargados en el sistema    
 * 	
 */
$manager = $this->getManager("ManagerPacientePrestador");
// $manager->debug();
$records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

echo $records;
?>
