<?php
/** 	
 * 	Accion: Registración de las empresas que contatan el pass de salud
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");


$result = $manager->login($this->request);

$this->finish($manager->getMsg());
?>
