<?php

/** 	
 * 	Accion: Alta genérica de los planes de prestadores
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPlanPrestador");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
