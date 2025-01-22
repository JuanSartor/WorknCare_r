<?php

  /**
   * Action >> Perfil Antecedentes
   */
  $manager = $this->getManager("ManagerPerfilSaludAntecedentes");

  $result = $manager->ningunAntecedenteFamiliar($this->request);

  $this->finish($manager->getMsg());
  