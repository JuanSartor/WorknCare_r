<?php

/** 	
 * 	Accion: Alta de las Especialidades - SubEspecialidades
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerTipoEnfermedad");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>
