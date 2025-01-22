<?php

/** 	
 * 	Accion: gestion de  Categorias de Programas de salud
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludGrupoEmpresa");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
