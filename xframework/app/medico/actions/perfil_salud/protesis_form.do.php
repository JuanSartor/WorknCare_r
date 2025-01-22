<?php

/**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludProtesis");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  