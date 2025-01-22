<?php
  
  //Id del paciente que el médico elije
  if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
      $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
  }else{
      $idpaciente=$this->request["idpaciente"];
  }
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $this->assign("paciente", $ManagerPaciente->get($idpaciente));
  
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
  