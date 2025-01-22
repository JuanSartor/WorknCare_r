<?php

  $header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

  //Si el filtro es distinto de "self" o de "all" va el filter selected,que es el id del paciente perteneciente al paciente
  $idpaciente = isset($header_paciente) && $header_paciente["filter_selected"] != "self" && $header_paciente["filter_selected"] != "all" ?
            $header_paciente["filter_selected"] :
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

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
  