<?php

  $this->start();
    $manager = $this->getManager("ManagerMedico");
    //$manager->debug();
    $result = $manager->controllerUpdateAllEntities($this->request);
    $this->finish($manager->getMsg());

