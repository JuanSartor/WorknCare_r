<?php

/** 	
 * 	Accion: Verificar de los pacientes con  prestador  ISIC
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerPacientePrestador");

$result = $manager->validar_paciente_ISIC($this->request);
$this->finish($manager->getMsg());
?>
