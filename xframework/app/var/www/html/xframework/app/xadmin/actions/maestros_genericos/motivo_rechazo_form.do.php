<?php

/** 	
 * 	Accion: gestion de  Motivo de Rechazo
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMotivoRechazo");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
