<?php


  /** 	
 * 	Accion: Registración de los aranceles de un médico
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPreferencia");


$result = $manager->registar_aranceles($this->request);
$this->finish($manager->getMsg());
