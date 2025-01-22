<?php

//actualizamos el contador de notificaciones
$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
$ManagerConsultaExpress->setNotificacionesLeidasPaciente(["idestadoConsultaExpress" => 5]);

$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
//Consulta Vencidas
$this->request["idestadoConsultaExpress"] = 5;

$consulta = $ManagerConsultaExpress->getConsultaExpressPaciente($this->request);

if (count($consulta) > 0) {
    $this->assign("consulta_vencida", $consulta);
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