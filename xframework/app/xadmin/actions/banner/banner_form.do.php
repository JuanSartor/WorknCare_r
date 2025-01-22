<?php

  /** 	
   * 	Accion: Alta - Modificación de los tipos de banner
   * 	
   */
  $this->start();

  $manager = $this->getManager("ManagerBanner");
  
  $result = $manager->process($this->request);
  
  $this->finish($manager->getMsg());
  