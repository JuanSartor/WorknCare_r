<?php

/** 	
 * 	Accion: Alta de los planes de las empresas
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludPlan");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
