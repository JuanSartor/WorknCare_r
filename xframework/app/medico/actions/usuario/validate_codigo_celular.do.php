<?php


  $ManagerMedico = $this->getManager("ManagerMedico");
  
  $result = $ManagerMedico->checkValidacionCelular($this->request);
  $this->finish($ManagerMedico->getMsg());
  
