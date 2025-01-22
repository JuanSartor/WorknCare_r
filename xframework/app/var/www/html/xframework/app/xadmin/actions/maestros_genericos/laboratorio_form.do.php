<?php

/** 	
 * 	Accion: Alta de los laboratorios
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerLaboratorio");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
