<?php

/** 	
 * 	Accion: Registración de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPaciente");

$result = $manager->registracion_paciente($this->request);
$this->finish($manager->getMsg());
?>
