<?php

/** 	
 * 	Accion: exportar los médicos en los programas de salud
 * 	
 */
$manager = $this->getManager("ManagerProgramaSalud");

$manager->ExportarMedicosProgramaSalud($this->request);

?>
