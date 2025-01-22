<?php


  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);

  //ME fijo si es paciente del grupo familiar
  if ($paciente["email"] == "") {
      $ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");
      $pacienteGrupo = $ManagerPacienteGrupoFamiliar->getByField("pacienteGrupo", $paciente["idpaciente"]);
      if ((int) $pacienteGrupo["relacionGrupo_idrelacionGrupo"] > 0) {
          $ManagerRelacionGrupo = $this->getManager("ManagerRelacionGrupo");
          $relacion = $ManagerRelacionGrupo->get($pacienteGrupo["relacionGrupo_idrelacionGrupo"]);
          if ($relacion) {
              $this->assign("relacion_grupo", "Su " . $relacion["relacionInversa"]);
          }
      }else{
              $this->assign("relacion_grupo", "Su parentezco" );
      }
  } else {
    $this->assign("relacion_grupo", "Usted");
  }

 



    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
 $this->assign("estadoTablero", $estadoTablero);

 $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
  $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
  
  $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
  $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);