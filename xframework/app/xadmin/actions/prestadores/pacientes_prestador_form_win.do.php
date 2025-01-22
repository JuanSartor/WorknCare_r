<?php

/** 	
 * 	Accion: Alta genérica de los prestadores
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPacientePrestador");
//$manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
