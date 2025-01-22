<?php

  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludProtesis");

  $result = $manager->deleteAll($this->request);

  $this->finish($manager->getMsg());

  