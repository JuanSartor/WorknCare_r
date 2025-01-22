<?php

  /** 	
   * 	Accion: Eliminación múltiple de la notificación
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->deleteMultipleNotificaciones($this->request["ids"], true);
  
  $this->finish($manager->getMsg());
  