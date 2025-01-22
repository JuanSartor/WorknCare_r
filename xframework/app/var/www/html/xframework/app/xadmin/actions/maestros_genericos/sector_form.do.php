<?php

/** 	
 * 	Accion: Alta de los sectors
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerSector");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
