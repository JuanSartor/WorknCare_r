<?php

  /**
   * Action >> Estado completado del perfil de salud
   */
  $manager = $this->getManager("ManagerPerfilSaludStatus");
  $ManagerPaciente = $this->getManager("ManagerPaciente");
  $paciente = $ManagerPaciente->getPacienteXHeader();
  $idpaciente = $paciente["idpaciente"];
$record=$manager->getStatusPerfilPacienteJSON($idpaciente);

  
echo $record;

  