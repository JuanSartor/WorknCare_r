<?php

  $this->assign("item_menu", "consults");

  $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  $idpaciente = $paciente["idpaciente"];


$ManagerPaciente=$this->getManager("ManagerPaciente");
  $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($idpaciente);
  $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
  $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
  $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);


  $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
  $this->assign("estadoTablero", $estadoTablero);

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

  $consulta = $ManagerPerfilSaludConsulta->getConsultaCompleta($this->request["idperfilSaludConsulta"]);

  if ($consulta) {
      $this->assign("consulta", $consulta);
  }
  
 