<?php


  /** 	
 * 	Accion: Registración de un consultorio para un médicos
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerMedico");
    $result = $manager->guardarInfoPersonal($this->request);
    $this->finish($manager->getMsg());
