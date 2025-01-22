<?php

  /**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludAlergia");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  