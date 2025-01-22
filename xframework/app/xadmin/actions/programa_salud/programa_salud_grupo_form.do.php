<?php

/** 	
 * 	Accion: gestion de  Categorias de Programas de salud
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludGrupo");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
