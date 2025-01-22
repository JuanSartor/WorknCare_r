<?php

  $ManagerPaciente = $this->getManager("ManagerPaciente");

  $paciente = $ManagerPaciente->getPacienteXHeader();
  $this->assign("paciente", $paciente);
  
  $this->assign("idpaciente", $paciente["idpaciente"]);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $paciente["idpaciente"]);

  if ($perfil_salud_biometrico) {
      $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
      $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($masa_corporal) {
          $this->assign("masa_corporal", $masa_corporal);
         
      }

      $ManagerPresionArterial = $this->getManager("ManagerPresionArterial");
      $presion_arterial = $ManagerPresionArterial->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($presion_arterial) {
          $this->assign("presion_arterial", $presion_arterial);
      }

      $ManagerColesterol = $this->getManager("ManagerColesterol");
      $colesterol = $ManagerColesterol->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($colesterol) {
          $this->assign("colesterol", $colesterol);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
  }
  