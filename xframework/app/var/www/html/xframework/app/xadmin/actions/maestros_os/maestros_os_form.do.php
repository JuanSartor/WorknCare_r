<?php

/** 	
 * 	Accion: Alta de las OBras Sociales - Prepagas
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerObrasSociales");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
