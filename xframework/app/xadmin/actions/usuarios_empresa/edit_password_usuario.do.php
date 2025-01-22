<?php

/** 	
 * 	Accion: Cambio de contraseña usuario empresa
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
//$manager->debug();
$result = $manager->changePasswordAdmin($this->request);
$this->finish($manager->getMsg());
