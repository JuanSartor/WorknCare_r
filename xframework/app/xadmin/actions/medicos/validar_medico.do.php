<?php

  /** 	
   * 	Accion: Validación por parte del administrador a un médico
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerMedico");

  $result = $manager->validarMedico($this->request);
  
  $this->finish($manager->getMsg());
  