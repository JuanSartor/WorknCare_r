<?php


  /** 	
 * 	Accion: Asocia una obra social a un médico
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerIdiomaMedico");
    $result = $manager->deleteIdioma($this->request["ididioma"]);
    $this->finish($manager->getMsg());
