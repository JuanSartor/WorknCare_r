<?php

//Consulta Pendiente
$this->request["idestadoConsultaExpress"] = 1;

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$idpaginate = "listado_paginado_consultas_pendientes_{$paciente["idpaciente"]}";
$this->assign("idpaginate", $idpaginate);

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressPaciente($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_consultas_pendientes", $listado);

    //print_r($listado);
}

// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express request SENT";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--    

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);
