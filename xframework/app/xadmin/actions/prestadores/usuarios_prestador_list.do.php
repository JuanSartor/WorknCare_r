<?php

/** 	
 * 	Accion: Grilla de los usuarios de prestadores cargados en el sistema    
 * 	
 */
$manager = $this->getManager("ManagerUsuarioPrestador");

$records = $manager->getUsuariosJSON($this->request,$manager->getDefaultPaginate());

echo $records;
?>
