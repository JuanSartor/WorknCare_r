<?php


  $this->start();
    $manager = $this->getManager("ManagerPreferencia");
    $result = $manager->guardarPreferenciaNotificacion($this->request);
    $this->finish($manager->getMsg());