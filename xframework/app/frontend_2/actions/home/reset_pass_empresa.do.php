<?php

/** 	
 * 	Accion: Reset Password
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
//$manager->debug();

$result = $manager->sendEmailRecuperarContrasenia($this->request);

$this->finish($manager->getMsg());

