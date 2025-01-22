<?php

  /**
   * Action de la creación de la notificación 
   */
  
  $manager = $this->getManager("ManagerNotificacion");
  
  $rdo = $manager->createNotificacionFromMisPacientesMensajeMedico($this->request);
  
  $this->finish($manager->getMsg());