<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");

  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
  
  $ManagerPerfilSaludEstiloVida = $this->getManager("ManagerPerfilSaludEstiloVida");
  $info_estilo_vida = $ManagerPerfilSaludEstiloVida->getDatosCard($paciente["idpaciente"]);
  $ManagerPerfilSaludEstiloVida->print_r($info_estilo_vida);
  $this->assign("info_estilo_vida", $info_estilo_vida);
  