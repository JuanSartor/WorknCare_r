<?php

//obtenemos el paciente

$idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];


$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente_titular = $ManagerPaciente->get($idpaciente, true);

$this->assign("paciente_titular", $paciente_titular);

//obtenemos el estado de avance del perfil completado
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

// <-- LOG
$log["data"] = "email, celular";
//$log["usertype"] = "Patient";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Account settings";
$log["purpose"] = "See User log-in data";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--


