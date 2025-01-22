<?php


  /** 	
   * 	Accion: Archivar las notificaciones
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->archivar($this->request);
  
  $this->finish($manager->getMsg());
  