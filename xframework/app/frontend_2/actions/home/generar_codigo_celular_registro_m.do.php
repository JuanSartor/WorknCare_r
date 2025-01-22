<?php

   
  $ManagerMedico = $this->getManager("ManagerMedico");
  
  $result = $ManagerMedico->sendSMSValidacion($this->request["idmedico"]);
  
  $this->finish($ManagerMedico->getMsg());
  
