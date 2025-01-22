<?php


  /** 	
   * 	Accion: Marcar como leído las notificaciones
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->marcarLeido($this->request, true);
  
  $this->finish($manager->getMsg());
  