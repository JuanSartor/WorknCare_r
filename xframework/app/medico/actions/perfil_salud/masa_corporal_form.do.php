<?php

  /**
   * Action >> Masa corporal
   */
  $manager = $this->getManager("ManagerMasaCorporal");
//$manager->debug();
  $result = $manager->insert($this->request);

  $this->finish($manager->getMsg());