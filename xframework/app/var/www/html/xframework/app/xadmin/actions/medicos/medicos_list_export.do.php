<?php

/** 	
 * 	Accion: exportar los médicos registrados  en formato CSV
 * 	
 */
$manager = $this->getManager("ManagerMedico");

 $manager->ExportarMedicosCSV($this->request);

?>
