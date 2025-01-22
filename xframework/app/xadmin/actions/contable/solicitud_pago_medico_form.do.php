<?php

  /** 	
   * 	Accion: Gestión de la solicitud de pago por parte de los médicos
   * 	
   */
  $this->start();
  $manager = $this->getManager("ManagerSolicitudPagoMedico");
// $manager->debug();
  $result = $manager->processFromAdmin($this->request);
  $this->finish($manager->getMsg());

  