<?php


  $this->start();
  
  $manager = $this->getManager("ManagerPerfilSaludMedicamento");
  
  $result = $manager->processFromPaciente($this->request);
  
  $this->finish($manager->getMsg());
  

