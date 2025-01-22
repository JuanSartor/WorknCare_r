<?php

  /**
   * Action para la eliminación 
   */
  $manager = $this->getManager("ManagerPerfilSaludCirugias");

  $result = $manager->deleteAll($this->request);

  $this->finish($manager->getMsg());

  