<?php

/** 	
 * 	Accion: Alta de las patologias
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerTipoPatologia");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
