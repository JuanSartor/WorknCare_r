<?php

  $this->assign("item_menu", "images");

  //Paciente que se encuentra en el array de SESSION de header paciente
  $ManagerPaciente = $this->getManager("ManagerPaciente");

  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
//  $ManagerPaciente->print_r($paciente);

  $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
  $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
  $this->assign("idpaginate", $paginate . "_" . $paciente["idpaciente"]);

  $this->request["idpaciente"] = $paciente["idpaciente"];
  $listado = $ManagerPerfilSaludEstudios->getListImages($this->request, $paginate . "_" . $paciente["idpaciente"]);
//  $ManagerPaciente->print_r($listado);die();
  if (count($listado["rows"]) > 0) {
      $this->assign("listado_imagenes", $listado);
      $this->assign("cantidad_imagenes", count($listado));
  }

  if (isset($this->request["is_thumb"]) && (int) $this->request["is_thumb"] == 1) {
      $this->assign("is_thumb", 1);
  } else {
      $this->assign("is_thumb", 0);
  }