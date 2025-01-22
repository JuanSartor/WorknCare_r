<?php

  
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
  if (isset($this->request["id"]) && $this->request["id"] != "") {
      $this->assign("idvacuna_vacunaEdad", $this->request["id"]);
      $ManagerPacienteVacunaVacunaEdad = $this->getManager("ManagerPacienteVacunaVacunaEdad");
      $vacuna_vacunaedad = $ManagerPacienteVacunaVacunaEdad->getXRelacion($paciente["idpaciente"], $this->request["id"]);
      
      $this->assign("record", $vacuna_vacunaedad);
  }


  require_once path_helpers('base/general/Calendar.class.php');

  $calendar = new Calendar();
  $this->assign("combo_dias", $calendar->getArrayDays());
  $this->assign("combo_meses", $calendar->getArrayMonths());
  $this->assign("combo_anios", $calendar->getArrayYears());
  