<?php


  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $result = $ManagerPaciente->sendSMSValidacion($this->request["idpaciente"]);
  
  $this->finish($ManagerPaciente->getMsg());
  
