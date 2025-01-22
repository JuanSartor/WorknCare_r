<?php

/** 	
 * 	Accion: modificacion del plan de los pacientes
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPacientePrestador");
//$manager->debug();
$result = $manager->cambiar_plan_paciente($this->request);
$this->finish($manager->getMsg());
?>
