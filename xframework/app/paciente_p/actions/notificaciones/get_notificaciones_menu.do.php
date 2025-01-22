<?php


  /** 	
   * 	Accion: cantidad de  notificaciones icono menu de home paciente
   * 	
   */
  $this->start();
  
  $manager = $this->getManager("ManagerPaciente");

  $result = $manager->get_notificaciones_menu($this->request["idpaciente"]);
   echo json_encode($result);

  