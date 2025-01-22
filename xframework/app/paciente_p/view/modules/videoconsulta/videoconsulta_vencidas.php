<?php

//actualizamos el contador de notificaciones
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");


$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
//Consulta Finalizadas
$this->request["idestadoVideoConsulta"] = 5;


$idpaginate = "listado_paginado_videoconsultas_vencidas_" . $paciente["idpaciente"];
$this->assign("idpaginate", $idpaginate);



$listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasPaciente($this->request, $idpaginate);
//$ManagerVideoConsulta->print_r($listado["rows"][1]);die();
if (count($listado["rows"]) > 0) {
    $this->assign("listado_videoconsultas_vencidas", $listado);
}
$this->assign("VENCIMIENTO_VC_RED", VENCIMIENTO_VC_RED);
$this->assign("VENCIMIENTO_VC_FRECUENTES", VENCIMIENTO_VC_FRECUENTES);


$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

// <-- LOG
$log["data"] = "-";
$log["page"] = "Video Consultation";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Video Consultation EXPIRED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--