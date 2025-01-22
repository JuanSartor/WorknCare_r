<?php

/** 	
 * 	Accion: Registración de los medicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMedico");


$result = $manager->registracion_medico($this->request);
$this->finish($manager->getMsg());
