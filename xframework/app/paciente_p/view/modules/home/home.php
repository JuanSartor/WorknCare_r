<?php
  /**
   *
   *  Home >>  Home
   *
   */

  $ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");

  $ManagerPaciente = $this->getManager("ManagerPaciente");

  $filtros = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

  if (isset($filtros["filter_selected"]) && $filtros["filter_selected"] == "all") {
      $ManagerPaciente->change_member_session(["requerimiento" => "self"]);
  }

  $listado = $ManagerPacienteGrupoFamiliar->getListadoPacienteConsultaExpress();
  $this->assign("listado", $listado);

  $cantidadFamiliares = $ManagerPacienteGrupoFamiliar->cantidadFamiliares();
  $this->assign("cantidadFamiliares", $cantidadFamiliares);

  //obtenemos el estado de avance del perfil completado
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente",$paciente);

  $statusPerfil = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
  $this->assign("statusPerfil", $statusPerfil);
  