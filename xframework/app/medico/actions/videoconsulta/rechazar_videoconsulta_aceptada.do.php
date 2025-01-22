<?php


  $manager = $this->getManager("ManagerVideoConsulta");
//  $manager->debug();
  $manager->rechazarVideoConsultaAceptada($this->request);
  
  $this->finish($manager->getMsg());

