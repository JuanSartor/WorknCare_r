<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerAntecedentesPersonales");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());