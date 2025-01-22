<?php

/** 	
 * 	Accion: Eliminacion mutiple
 *
 *
 */
$manager = $this->getManager("ManagerProgramaSaludCupon");

$manager->deleteMultiple($this->request['ids'], true);

$this->finish($manager->getMsg());
?>
