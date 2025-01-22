<?php


  /** 	
   * 	Accion: Establecer la recomenacion de un medico por el paciente
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerProfesionalValoracion");

  $result = $manager->processValoracion($this->request);
  
  $this->finish($manager->getMsg());
  