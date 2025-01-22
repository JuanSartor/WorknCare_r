<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPatologiasActuales");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());