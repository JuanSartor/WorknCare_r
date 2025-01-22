<?php


  $ManagerMedico = $this->getManager("ManagerMedico");
  
  $result = $ManagerMedico->enviarMailCodigoValidacionEmail();
  $this->finish($ManagerMedico->getMsg());
  
