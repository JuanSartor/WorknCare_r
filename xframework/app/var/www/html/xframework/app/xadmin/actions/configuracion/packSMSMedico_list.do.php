<?php

/** 	
 * 	Accion: Grilla del Listado de Los packs de SMS del Médico
 * 	
 */
$manager = $this->getManager("ManagerPackSMSMedico");
//$manager->debug();
$records = $manager->getListadoJSON($manager->getDefaultPaginate(), $this->request);

echo $records;
?>
