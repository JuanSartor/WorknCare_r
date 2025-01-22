<?php
  
  
  //Id del paciente que el médico elije
  if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
      $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
  }else{
      $idpaciente=$this->request["idpaciente"];
  }

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
  