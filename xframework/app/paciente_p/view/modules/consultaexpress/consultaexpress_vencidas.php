<?php

//actualizamos el contador de notificaciones
$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");


$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
//Consulta Finalizadas
$this->request["idestadoConsultaExpress"] = 5;


$idpaginate = "listado_paginado_consultas_vencidas_" . $paciente["idpaciente"];
$this->assign("idpaginate", $idpaginate);



$listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressPaciente($this->request, $idpaginate);
//$ManagerConsultaExpress->print_r($listado["rows"][1]);die();
if (count($listado["rows"]) > 0) {
    $this->assign("listado_consultas_vencidas", $listado);
}

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

$this->assign("VENCIMIENTO_CE_RED", VENCIMIENTO_CE_RED);
$this->assign("VENCIMIENTO_CE_FRECUENTES", VENCIMIENTO_CE_FRECUENTES);

// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express EXPIRED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  