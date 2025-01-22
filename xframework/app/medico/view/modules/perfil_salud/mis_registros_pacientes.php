<?php

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

  $this->assign("idpaginate", "mis_registros_pacientes_" . $this->request["idpaciente"]);
  $this->assign("idpaciente", $this->request["idpaciente"]);

//  $ManagerPerfilSaludConsulta->debug();
  
  $listado = $ManagerPerfilSaludConsulta->getListadoPaginado($this->request, "mis_registros_pacientes_" . $this->request["idpaciente"]);

  if ($listado) {
      $this->assign("listado", $listado);
  }
  
  if($this->request["mis_registros_consultas_medicas"]==1){
       $ManagerMedico = $this->getManager("ManagerMedico");
      $paciente = $ManagerMedico->getPacienteMedico($this->request["idpaciente"]);
      if ($paciente) {
          $this->assign("paciente", $paciente);
      }
  }