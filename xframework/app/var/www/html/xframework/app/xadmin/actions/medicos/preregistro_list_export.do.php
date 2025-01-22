<?php

/** 	
 * 	Accion: exportar los médicos registrados desde el frontend y que no han completado el registro en formato CSV
 * 	
 */
$manager = $this->getManager("ManagerPreregistro");

 $manager->ExportarCSV($this->request);

?>
