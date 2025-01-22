<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
  $ManagerTablero = $this->getManager("ManagerTablero");
  $listado = $ManagerTablero->getListTableroFront($paciente["idpaciente"]);
  if($listado){
    
      $this->assign("tablero_list", $listado);
  }
