<?php

/** 	
 * 	Accion: Alta de los Tipo de Familiar
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerTipoFamiliar");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
