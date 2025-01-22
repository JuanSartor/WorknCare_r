<?php

  /**
   * Action >> ManagerGlucemia
   */
  $manager = $this->getManager("ManagerGlucemia");

  $result = $manager->insert($this->request);

  $this->finish($manager->getMsg());