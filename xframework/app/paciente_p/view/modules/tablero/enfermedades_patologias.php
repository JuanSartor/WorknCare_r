<?php

  $idpaciente = $this->request["idpaciente"];

  $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");
  $list_patologias_actuales = $ManagerPatologiasActuales->getInfoTablero($idpaciente);
  if ($list_patologias_actuales && count($list_patologias_actuales) > 0) {
      $this->assign("list_patologias_actuales", $list_patologias_actuales);
  }
  
  $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
  $list_enfermedades_actuales = $ManagerEnfermedadesActuales->getInfoTablero($idpaciente);
  if ($list_enfermedades_actuales && count($list_enfermedades_actuales) > 0) {
      $this->assign("list_enfermedades_actuales", $list_enfermedades_actuales);
  }