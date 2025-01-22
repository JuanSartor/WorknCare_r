<?php

  /** 	
   * 	Accion: Alta genérica de las notificaciones de los medicos
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerNotificacionSistema");
//$manager->debug();
  $result = $manager->process($this->request);
  $this->finish($manager->getMsg());
  