<?php


  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $result = $ManagerPaciente->checkValidacionEmail($this->request);
  $this->finish($ManagerPaciente->getMsg());
  
