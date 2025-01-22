<?php
  /** 	
 * 	Accion: Asocia una idioma a un médico
 * 	
 */
    $this->start();
    $manager = $this->getManager("ManagerIdiomaMedico");
    $result = $manager->addIdioma($this->request["ididioma"]);
    $this->finish($manager->getMsg());
