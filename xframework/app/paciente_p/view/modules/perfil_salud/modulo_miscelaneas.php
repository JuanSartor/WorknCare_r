<?php

  $header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

  //Si el filtro es distinto de "self" o de "all" va el filter selected,que es el id del paciente perteneciente al paciente
  $idpaciente = isset($header_paciente) && $header_paciente["filter_selected"] != "self" && $header_paciente["filter_selected"] != "all" ?
            $header_paciente["filter_selected"] :
            $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"];

  $this->assign("idpaciente", $idpaciente);

  $ManagerPerfilSaludBiometrico = $this->getManager("ManagerPerfilSaludBiometrico");
  $perfil_salud_biometrico = $ManagerPerfilSaludBiometrico->getWithData($idpaciente);
  $this->assign("perfil_salud_biometrico", $perfil_salud_biometrico);

  $ManagerColorOjos = $this->getManager("ManagerColorOjos");
  $this->assign("combo_ojos", $ManagerColorOjos->getCombo());

  $ManagerColorPiel = $this->getManager("ManagerColorPiel");
  $this->assign("combo_piel", $ManagerColorPiel->getCombo());

  $ManagerColorPelo = $this->getManager("ManagerColorPelo");
  $this->assign("combo_pelo", $ManagerColorPelo->getCombo());

  $ManagerGrupoFactorSanguineo = $this->getManager("ManagerGrupoFactorSanguineo");
  $this->assign("combo_fs", $ManagerGrupoFactorSanguineo->getCombo());