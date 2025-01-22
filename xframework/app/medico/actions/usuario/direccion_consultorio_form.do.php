<?php


  /** 	
 * 	Accion: Registración de direccion de consultorio para un médicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerDireccion");

$result = $manager->processDireccionMedico($this->request);
$this->finish($manager->getMsg());
