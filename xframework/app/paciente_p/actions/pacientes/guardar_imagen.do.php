<?php

  $this->start();
  $manager = $this->getManager("ManagerPaciente");

  $result = $manager->guardar_imagen($this->request);
  $this->finish($manager->getMsg());
