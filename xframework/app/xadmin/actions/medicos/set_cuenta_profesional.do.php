<?php

  /** 	
   * 	Accion: Actualizacion de plan profesional en el medico desde el administrador
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerSuscripcionPremium");

  $result = $manager->processSuscripcionFromXadmin($this->request);
  $this->finish($manager->getMsg());
  