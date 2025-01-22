<?php

//Consulta Abierta
$this->request["idestadoConsultaExpress"] = 2;

$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
$idpaginate = "listado_paginado_consultas_abiertas_{$paciente["idpaciente"]}";
$this->assign("idpaginate", $idpaginate);

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressPaciente($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_consultas_abiertas", $listado);
}

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

//print_r($cantidad_consulta);
// <-- LOG
$log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express ONGOING";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  