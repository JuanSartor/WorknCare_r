<?php
/** 	
 * 	Accion: Registración de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioWeb");
//$manager->debug();

$result = $manager->login($this->request);

$this->finish($manager->getMsg());
?>
