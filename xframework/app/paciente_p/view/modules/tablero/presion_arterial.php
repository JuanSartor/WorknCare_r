<?php

  $idpaciente = $this->request["idpaciente"];

  $this->assign("idpaciente", $idpaciente);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);

  if ($perfil_salud_biometrico) {
      $ManagerPresionArterial = $this->getManager("ManagerPresionArterial");
      $presion_arterial = $ManagerPresionArterial->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($presion_arterial) {
          $this->assign("presion_arterial", $presion_arterial);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
  }