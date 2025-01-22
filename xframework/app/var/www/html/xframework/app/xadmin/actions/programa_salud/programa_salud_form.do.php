<?php

/** 	
 * 	Accion: gestion de  Programas de salud
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSalud");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
