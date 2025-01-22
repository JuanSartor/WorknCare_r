<?php

/** 	
 * 	Accion: exportar los pacientes registrados 
 * 	
 */
$manager = $this->getManager("ManagerPaciente");

 $manager->ExportarPacientesCSV($this->request);

?>
