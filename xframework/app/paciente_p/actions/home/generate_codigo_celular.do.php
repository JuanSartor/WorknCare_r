<?php


  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $result = $ManagerPaciente->sendSMSValidacion();
  
  $this->finish($ManagerPaciente->getMsg());
  
