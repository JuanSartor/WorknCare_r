<?php


  $this->start();
    $manager = $this->getManager("ManagerPreferencia");
    $result = $manager->guardarPreferenciaServicios($this->request);
    $this->finish($manager->getMsg());