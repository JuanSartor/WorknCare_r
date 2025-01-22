<?php

  /**
   * Action de modificación / creación de las solicitudes de los pagos de los médicos
   */
  $this->start();
  $manager = $this->getManager("ManagerSolicitudPagoMedico");
  //$manager->debug();
  $result = $manager->processSolicitudPagoMedico($this->request);
  $this->finish($manager->getMsg());

