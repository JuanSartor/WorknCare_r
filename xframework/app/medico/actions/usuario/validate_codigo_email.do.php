<?php


  $ManagerMedico = $this->getManager("ManagerMedico");
  
  $result = $ManagerMedico->checkValidacionEmail($this->request);
  $this->finish($ManagerMedico->getMsg());
  
