<?php

  $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

  $this->assign("idpaginate", "registro_historico_consultas_list_".$this->request["idpaciente"]);
  $this->assign("idpaciente", $this->request["idpaciente"]);
$ManagerMedico = $this->getManager("ManagerMedico");
      $paciente = $ManagerMedico->getPacienteMedico( $this->request["idpaciente"]);
      if ($paciente) {
          $this->assign("paciente", $paciente);
      }
//  $ManagerPerfilSaludConsulta->debug();
  
  $listado = $ManagerPerfilSaludConsulta->getListadoOtrosProfesionalesPaginado($this->request, "registro_historico_consultas_list_".$this->request["idpaciente"]);

  if ($listado) {
      $this->assign("listado", $listado);
     
  }