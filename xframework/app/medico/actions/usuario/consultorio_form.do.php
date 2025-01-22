<?php


  /** 	
 * 	Accion: Registración de un consultorio para un médicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerConsultorio");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
