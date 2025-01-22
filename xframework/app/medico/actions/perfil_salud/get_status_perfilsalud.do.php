<?php

  /**
   * Action >> Estado completado del perfil de salud
   */
  $manager = $this->getManager("ManagerPerfilSaludStatus");
  
$idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
$record=$manager->getStatusPerfilPacienteJSON($idpaciente);
  
echo $record;

  