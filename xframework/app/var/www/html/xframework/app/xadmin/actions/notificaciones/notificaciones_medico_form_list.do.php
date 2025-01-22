<?php

  
  /** 	
   * 	Accion: Notificaciones de medicos form -> LIST
   * 	
   */
  $manager = $this->getManager("ManagerNotificacionSistema");
//$manager->debug();
  $records = $manager->getListadoFormNotificacionMedicoJSON($this->request);

  echo $records;
  
