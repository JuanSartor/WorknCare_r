<?php

  /**
   * Action >> Presión arterial
   */
  $manager = $this->getManager("ManagerPresionArterial");

  $result = $manager->insert($this->request);

  $this->finish($manager->getMsg());