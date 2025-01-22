<?php

/** 	
 * 	Accion: gestion de  Motivo de Consulta Express
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMotivoConsultaExpress");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
