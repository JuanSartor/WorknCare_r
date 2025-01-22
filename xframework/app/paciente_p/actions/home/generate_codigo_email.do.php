<?php


  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $result = $ManagerPaciente->enviarMailCodigoValidacionEmail();
  $this->finish($ManagerPaciente->getMsg());
  
