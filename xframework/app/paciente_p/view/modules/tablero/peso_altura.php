<?php

  $idpaciente = $this->request["idpaciente"];
  
  $this->assign("idpaciente", $idpaciente);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);

  if ($perfil_salud_biometrico) {
      $ManagerMasaCorporal = $this->getManager("ManagerMasaCorporal");
      $masa_corporal = $ManagerMasaCorporal->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($masa_corporal) {
          $this->assign("masa_corporal", $masa_corporal);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
  }
  