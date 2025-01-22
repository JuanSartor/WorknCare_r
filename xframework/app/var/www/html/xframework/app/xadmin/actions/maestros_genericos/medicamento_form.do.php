<?php

/** 	
 * 	Accion: Alta de los medicamentos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMedicamento");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
