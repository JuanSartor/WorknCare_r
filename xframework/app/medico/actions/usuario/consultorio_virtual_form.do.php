<?php


  /** 	
 * 	Accion: Registración de un consultorio para un médicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerConsultorio");

$result = $manager->processVirtual($this->request);
$this->finish($manager->getMsg());
