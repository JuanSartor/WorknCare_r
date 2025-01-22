<?php

/** 	
 * 	Accion: Alta de los cupones de las empresas
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludCupon");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
