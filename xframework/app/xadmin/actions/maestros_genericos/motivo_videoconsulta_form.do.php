<?php

/** 	
 * 	Accion: gestion de  Motivo de Video Consulta
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMotivoVideoConsulta");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
