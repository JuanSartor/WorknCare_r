<?php

  /** 	
   * 	Accion: Notificaciones de medicos -> LIST
   * 	
   */
  $manager = $this->getManager("ManagerNotificacionSistema");
//$manager->debug();
  $this->request["is_notificacion_medico"] = 1;
  $records = $manager->getListadoNotificacionesSistemaJSON($this->request, $manager->getDefaultPaginate() . "_medico");

  echo $records;
  