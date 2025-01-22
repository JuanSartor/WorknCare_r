<?php

/** 	
 * 	Accion: Alta de los bancos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerBanco");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
