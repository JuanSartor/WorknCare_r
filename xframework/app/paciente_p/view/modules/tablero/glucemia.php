<?php

  $idpaciente = $this->request["idpaciente"];
  
  $this->assign("idpaciente", $idpaciente);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);

  if ($perfil_salud_biometrico) {
      $ManagerGlucemia = $this->getManager("ManagerGlucemia");
      $glucemia = $ManagerGlucemia->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($glucemia) {
          $this->assign("glucemia", $glucemia);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
  }
  