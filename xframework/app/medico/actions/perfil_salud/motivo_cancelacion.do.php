<?php

 
  /**
   * Action >> Miscelaneas
   */
  $manager = $this->getManager("ManagerSolicitudRenovacionPerfilSaludMedicamento");

  $result = $manager->rechazarSolicitudRenovacion($this->request);

  $this->finish($manager->getMsg());