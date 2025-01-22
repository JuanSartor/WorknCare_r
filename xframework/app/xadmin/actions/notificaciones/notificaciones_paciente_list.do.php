<?php

  /** 	
   * 	Accion: Notificaciones de pacientes -> LIST
   * 	
   */
  $manager = $this->getManager("ManagerNotificacionSistema");
//$manager->debug();
  $records = $manager->getListadoNotificacionesSistemaJSON($this->request, $manager->getDefaultPaginate() . "_paciente");

  echo $records;
  