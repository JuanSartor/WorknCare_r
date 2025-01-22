<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");

  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);

  $ManagerPerfilSaludGinecologico = $this->getManager("ManagerPerfilSaludGinecologico");



  //Si el paciente es femenino 
  if ($paciente["sexo"] == 0) {
      //Busco el perfil de salud ginecológico
      $perfil_salud_ginecologico = $ManagerPerfilSaludGinecologico->getPerfilSaludXIDPaciente($paciente["idpaciente"]);
      if ($perfil_salud_ginecologico) {
          $this->assign("record", $perfil_salud_ginecologico);
         
      }
      $this->assign("card", true);
  }

  require_once path_helpers('base/general/Calendar.class.php');

  $calendar = new Calendar();
  $this->assign("combo_dias", $calendar->getArrayDays());
  $this->assign("combo_meses", $calendar->getArrayMonths());
  $this->assign("combo_anios", $calendar->getArrayYears());

  