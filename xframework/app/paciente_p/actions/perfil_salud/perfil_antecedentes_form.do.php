<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludAntecedentes");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());