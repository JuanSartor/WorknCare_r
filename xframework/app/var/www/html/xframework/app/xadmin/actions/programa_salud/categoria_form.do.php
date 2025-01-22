<?php

/** 	
 * 	Accion: gestion de  Categorias de Programas de salud
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludCategoria");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
