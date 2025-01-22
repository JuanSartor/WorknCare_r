<?php

//videoconsulta Pendiente
$this->request["idestadoVideoConsulta"] = 1;

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$consulta = $ManagerVideoConsulta->getVideoConsultaPaciente($this->request);

if (count($consulta) > 0) {
    $this->assign("consulta", $consulta);
}

$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

// <-- LOG
$log["data"] = "-";
$log["page"] = "Video Consultation";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Video Consultation request SENT";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--
  