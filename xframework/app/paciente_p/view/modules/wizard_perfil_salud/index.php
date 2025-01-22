<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");

$paciente = $ManagerPaciente->getPacienteXHeader();
$ManagerPaciente->no_completar_perfil_salud_home();

$perfil_salud = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
//wizard perfil ya finalizado
if ($pefil_salud && $pefil_salud["wizard_step"]!="") {
    $step = $pefil_salud["wizard_step"];
} else {
    $step = 1;
}
$this->assign("wizard_step", $step);
$this->includeSubmodule("wizard_perfil_salud", "wizard_step_" . $step);
