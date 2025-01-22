<?php

/** 	
 * 	Accion: gestion de  Familia de cuestionario
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerModeloRiesgo");
// $manager->debug();
$result = $manager->process($this->request);
echo $this->finish($manager->getMsg());
