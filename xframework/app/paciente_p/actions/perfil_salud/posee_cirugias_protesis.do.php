<?php

/**
   * Action >> Perfil cirguias y protesis
   */
  $manager = $this->getManager("ManagerPerfilSaludCirugiasProtesis");

  $result = $manager->process($this->request);

  $this->finish($manager->getMsg());
  