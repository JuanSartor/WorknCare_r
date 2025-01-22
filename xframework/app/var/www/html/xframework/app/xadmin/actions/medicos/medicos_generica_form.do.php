<?php

/** 	
 * 	Accion: Alta genérica de los médicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMedico");

$result = $manager->processFromAdmin($this->request);
$this->finish($manager->getMsg());
?>