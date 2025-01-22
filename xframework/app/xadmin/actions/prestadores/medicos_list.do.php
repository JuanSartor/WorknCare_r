<?php

/** 	
 * 	Accion: Grilla de los prestadores cargados en el sistema    
 * 	
 */
$manager = $this->getManager("ManagerMedicoPrestador");

$records = $manager->getListadoMedicosJSON( $this->request,$manager->getDefaultPaginate());

echo $records;
?>
