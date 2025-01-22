<?php

  $idpaciente = $this->request["idpaciente"];

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

  