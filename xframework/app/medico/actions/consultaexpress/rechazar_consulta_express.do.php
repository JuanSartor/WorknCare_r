<?php


  $manager = $this->getManager("ManagerConsultaExpress");
//  $manager->debug();
  $manager->rechazarConsultaExpress($this->request);
  
  $this->finish($manager->getMsg());

