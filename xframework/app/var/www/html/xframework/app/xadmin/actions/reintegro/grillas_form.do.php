<?php

/** 	
 * 	Accion: Alta genérica de los médicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerGrilla");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>