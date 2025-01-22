<?php

  /**
   * Action >> Masa corporal
   */
  $manager = $this->getManager("ManagerMasaCorporal");

  $result = $manager->insert($this->request);
  
  

  $this->finish($manager->getMsg());