<?php

  /**
   * Action >> Miscelaneas
   */
  $manager = $this->getManager("ManagerPerfilSaludBiometrico");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());