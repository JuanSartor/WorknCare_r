<?php

  $idpaciente = $this->request["idpaciente"];

  $this->assign("idpaciente", $idpaciente);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getByField("paciente_idpaciente", $idpaciente);

  if ($perfil_salud_biometrico) {
      $ManagerColesterol = $this->getManager("ManagerColesterol");
      $colesterol = $ManagerColesterol->getLastInformation($perfil_salud_biometrico["idperfilSaludBiometricos"]);
      if ($colesterol) {
          $this->assign("colesterol", $colesterol);
      }

      $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);
  }
  