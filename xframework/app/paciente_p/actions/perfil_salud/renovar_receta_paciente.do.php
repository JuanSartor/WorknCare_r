<?php


  /**
   * Action >> Colesterol
   */
  $manager = $this->getManager("ManagerPerfilSaludMedicamento");

  $result = $manager->processSolicitudRenovacion($this->request);

  $this->finish($manager->getMsg());