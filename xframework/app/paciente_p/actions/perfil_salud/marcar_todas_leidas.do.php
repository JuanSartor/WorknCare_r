<?php

  /** 	
   * 	Accion: Marcar como leído todas las notificaciones de controles y chequeos
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->marcarLeidoTodasNotificacionesControlesChequeo($this->request, true);
  
  $this->finish($manager->getMsg());
  