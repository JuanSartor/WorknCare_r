<?php

  
  /** 	
   * 	Accion: Envío de invitación de Paciente
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerNotificacion");

  $result = $manager->createNotificacionFromMisPacientesMensajeMedico($this->request);

  $this->finish($manager->getMsg());
  