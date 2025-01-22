<?php

  $this->start();
  
  $manager = $this->getManager("ManagerPerfilSaludMedicamento");
  
  $result = $manager->processFromMedico($this->request);
  
  $this->finish($manager->getMsg());
  

