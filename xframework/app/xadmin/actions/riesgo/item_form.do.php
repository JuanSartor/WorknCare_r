<?php

/** 	
 * 	Accion: gestion de Cuestionarios
 * 	
 */
$this->start();

$manager = $this->getManager("ManagerItemRiesgo");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
