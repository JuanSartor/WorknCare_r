<?php


  $ManagerMedico = $this->getManager("ManagerMedico");
  
  $result = $ManagerMedico->sendSMSValidacion();
  $this->finish($ManagerMedico->getMsg());
  
