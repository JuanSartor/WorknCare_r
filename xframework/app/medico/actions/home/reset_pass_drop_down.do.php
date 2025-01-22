<?php

/** 	
 * 	Accion: Reset Password
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioWeb");
//$manager->debug();

$result = $manager->sendEmailRecuperarContrasenia($this->request);

$this->finish($manager->getMsg());

