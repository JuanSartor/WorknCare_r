<?php


  $this->start();
    $manager = $this->getManager("ManagerPreferencia");
    $result = $manager->registrarRenovacionAutomatica($this->request["renovar"]);
    $this->finish($manager->getMsg());