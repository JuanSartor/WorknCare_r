<?php

  /** 	
 * 	Accion: Registración de los preferencia de agenda en el consultorio de un médico
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMedico");


$result = $manager->setear_agenda_consultorio($this->request);
$this->finish($manager->getMsg());
