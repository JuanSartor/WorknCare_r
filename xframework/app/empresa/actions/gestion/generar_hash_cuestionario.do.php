<?php

/** 	
 * 	Accion: genera otro hash de invitacion y codigo para el cuestionario
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");

$result = $manager->generar_hash_invitacion_cuestionario($this->request["idcuestionario"]);
$this->finish($manager->getMsg());

