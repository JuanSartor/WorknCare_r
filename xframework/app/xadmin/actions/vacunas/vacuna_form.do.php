<?php

  /** 	
   * 	Accion: Alta de los vacunas
   * 	
   */
  $this->start();

  $manager = $this->getManager("ManagerVacuna");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  