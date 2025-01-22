<?php

/** 	
 * 	Accion: Alta de los embajadores de las empresas
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerEmbajador");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
