<?php

  /** 	
   * 	Accion: Envío de mensajes a Paciente
   * 	
   */

  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->createNotificacionMensajeMedicoPaciente($this->request);

  $this->finish($manager->getMsg());
  