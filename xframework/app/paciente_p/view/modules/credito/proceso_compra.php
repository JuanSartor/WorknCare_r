<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);


$ManagerMetodoPago = $this->getManager("ManagerMetodoPago");
$this->assign("combo_metodo_pago", $ManagerMetodoPago->getCombo());

/* $enlace = $ManagerMetodoPago->getEnlaceMP($this->request);
  if($enlace){
  $this->assign("enlace_mp", $enlace);
  } */


// <-- LOG
$log["data"] = "Available amount, historical payments";
$log["action"] = "val"; //"val" "vis" "del"
$log["page"] = "Account settings";
$log["purpose"] = "Credit User account";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--          