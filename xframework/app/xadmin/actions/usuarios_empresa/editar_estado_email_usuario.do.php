<?php

/** 	
 * 	Accion: Cambio de estado al mail Usuario
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
//$manager->debug();
$result = $manager->changeConditionEmail($this->request);
$this->finish($manager->getMsg());
