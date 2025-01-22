<?php

/** 	
 * 	Accion: Cancelar un suscripcion de forma anticipada desde el admin
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
//$manager->debug();
$result = $manager->cancelar_suscripcion_from_admin($this->request["idempresa"]);
$this->finish($manager->getMsg());
