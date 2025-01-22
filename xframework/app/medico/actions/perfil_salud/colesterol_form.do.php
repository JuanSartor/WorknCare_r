<?php

  /**
   * Action >> Colesterol
   */
  $manager = $this->getManager("ManagerColesterol");

  $result = $manager->insert($this->request);

  $this->finish($manager->getMsg());