<?php


  $manager = $this->getManager("ManagerVideoConsulta");
//  $manager->debug();
  $manager->rechazarVideoConsulta($this->request);
  
  $this->finish($manager->getMsg());

