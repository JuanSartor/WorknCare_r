<?php

  /** 	
   * 	Accion: Alta genérica de los pacientes
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerUsuarioPrestador");
//$manager->debug();
  
  $result = $manager->changePasswordAdmin($this->request);
  $this->finish($manager->getMsg());
  