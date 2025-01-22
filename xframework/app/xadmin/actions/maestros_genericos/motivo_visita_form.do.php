<?php

/** 	
 * 	Accion: Alta de las Titulo Profesional
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMotivoVisita");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
