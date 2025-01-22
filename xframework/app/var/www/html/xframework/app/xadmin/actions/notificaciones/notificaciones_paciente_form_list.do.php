<?php

  
  /** 	
   * 	Accion: Notificaciones de pacientes form -> LIST
   * 	
   */
  $manager = $this->getManager("ManagerNotificacionSistema");
//$manager->debug();
  $records = $manager->getListadoFormNotificacionPacienteJSON($this->request);

  echo $records;
  
