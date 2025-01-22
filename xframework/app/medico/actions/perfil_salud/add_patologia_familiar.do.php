<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerAntecedentesPatologiaFamiliar");

  $result = $manager->addAntecedentePatologiaFamiliar($this->request);

  $this->finish($manager->getMsg());
  