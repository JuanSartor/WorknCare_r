<?php

/** 	
 * 	Accion: Alta genérica de los prestadores
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioPrestador");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
