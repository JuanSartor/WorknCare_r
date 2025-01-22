<?php

//Consulta Pendiente
$this->request["idestadoConsultaExpress"] = 1;

//Paciente que se encuentra en el array de SESSION de header paciente
$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$consulta = $ManagerConsultaExpress->getConsultaExpressPaciente($this->request);

if (count($consulta) > 0) {
    $this->assign("consulta", $consulta);
}

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);
// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express request SENT";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  