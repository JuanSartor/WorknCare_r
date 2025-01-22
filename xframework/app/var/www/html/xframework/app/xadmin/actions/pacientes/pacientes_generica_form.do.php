<?php

/** 	
 * 	Accion: Alta genérica de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPaciente");
//$manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
