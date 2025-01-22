<?php

/** 	
 * 	Accion: Actualizo la validacion del reembolso
 * 	
 */
$this->start();

$manager = $this->getManager("ManagerReembolso");
//// $manager->debug();
$result = $manager->validarReembolso($this->request);
$this->finish($manager->getMsg());
