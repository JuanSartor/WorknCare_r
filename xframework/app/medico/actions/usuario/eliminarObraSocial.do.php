<?php


  /** 	
 * 	Accion: Asocia una obra social a un médico
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerObraSocialMedico");
    $result = $manager->deleteObracial($this->request["idobraSocial"]);
    $this->finish($manager->getMsg());
