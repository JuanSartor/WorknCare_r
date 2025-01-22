<?php

/**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerProfesionalesFrecuentesPacientes");
  
  $result = $manager->deleteMultiple($this->request["ids"]);
  
  $this->finish($manager->getMsg());
