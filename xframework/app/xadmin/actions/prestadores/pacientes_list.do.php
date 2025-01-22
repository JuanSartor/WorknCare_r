<?php

/** 	
 * 	Accion: Grilla de pacientes de los prestadores cargados en el sistema    
 * 	
 */
$manager = $this->getManager("ManagerPacientePrestador");

$records = $manager->getListadoPacientesJSON( $this->request,$manager->getDefaultPaginate());

echo $records;
?>
