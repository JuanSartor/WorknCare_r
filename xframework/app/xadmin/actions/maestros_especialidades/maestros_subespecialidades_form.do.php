<?php

/** 	
 * 	Accion: Alta de las Especialidades - SubEspecialidades
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerSubEspecialidades");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
