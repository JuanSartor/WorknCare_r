<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);


$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);


/* * verificamos si quedo una consulta en borrador* */
$ConsultaExpress = $this->getManager("ManagerConsultaExpress")->getConsultaExpressBorrador($paciente["idpaciente"]);
$this->assign("ConsultaExpress", $ConsultaExpress);




// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express panel";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--       