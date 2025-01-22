<?php

  /**
   * Action >> Enfermedades Actuales
   */
  $manager = $this->getManager("ManagerEnfermedadesActuales");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());