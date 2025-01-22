<?php

  $this->start();
  
  $manager = $this->getManager("ManagerMedico");
  
  $result = $manager->getMedicoCompartirList($this->request);
  
  $this->finish($result);
  
