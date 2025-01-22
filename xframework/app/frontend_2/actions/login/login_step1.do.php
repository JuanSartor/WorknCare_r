<?php
/** 	
 * 	Accion: Registración de los pacientes
 * 	
 */
$this->start();

$manager = $this->getManager("ManagerUsuarioWeb");


$result = $manager->login_step1($this->request);

$this->finish($manager->getMsg());
?>
