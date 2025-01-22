<?php


  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $result = $ManagerPaciente->checkValidacionCelular($this->request);
  $this->finish($ManagerPaciente->getMsg());
  
