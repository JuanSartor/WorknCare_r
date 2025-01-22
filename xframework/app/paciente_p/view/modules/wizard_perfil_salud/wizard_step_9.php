<?php

// Debo instanciar el paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");

//Paciente que se encuentra en el array de SESSION de header paciente
$paciente = $ManagerPaciente->getPacienteXHeader();

$this->assign("paciente", $paciente);


$this->getManager("ManagerPerfilSaludStatus")->update_wizard_step(9, $paciente["idpaciente"]);
