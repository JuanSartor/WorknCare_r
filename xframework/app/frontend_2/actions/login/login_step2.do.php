<?php
/** 	
 * 	Accion: Registración de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioWeb");


$result = $manager->login($this->request);

$this->finish($manager->getMsg());
?>
