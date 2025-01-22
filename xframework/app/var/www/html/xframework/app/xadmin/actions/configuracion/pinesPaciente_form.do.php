<?php

/** 	
 * 	Accion: Alta - Modificación de los packs de SMS Medico
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPinesPaciente");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
