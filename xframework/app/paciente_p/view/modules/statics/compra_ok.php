<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);
// <-- LOG
$log["data"] = "Payment successful";
$log["page"] = "Account settings";
$log["action"] = "val"; //"vis" "del"
$log["purpose"] = "Credit User account";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--
