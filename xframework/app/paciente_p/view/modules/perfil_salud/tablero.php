<?php

  // Debo instanciar el paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
    
  $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);

   $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
  $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
  $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
  $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);