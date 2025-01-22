<?php

/** 	
 * 	Accion: Registración del mensaje personalizado de la empresa contratante
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");


$result = $manager->setearMensajeComplementario($this->request);
$this->finish($manager->getMsg());

