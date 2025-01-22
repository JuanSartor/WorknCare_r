<?php

/**
   * Action >> Perfil Alergias
   */
  $manager = $this->getManager("ManagerPerfilSaludCirugias");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  