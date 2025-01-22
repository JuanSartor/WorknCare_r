<?php

//actualizamos el contador de notificaciones
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->setNotificacionesLeidasPaciente(["idestadoVideoConsulta" => 5]);

$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
//Consulta Vencidas
$this->request["idestadoVideoConsulta"] = 5;

$consulta = $ManagerVideoConsulta->getVideoConsultaPaciente($this->request);

if (count($consulta) > 0) {
    $this->assign("videoconsulta_vencida", $consulta);
}
$this->assign("VENCIMIENTO_VC_RED", VENCIMIENTO_VC_RED);
$this->assign("VENCIMIENTO_VC_FRECUENTES", VENCIMIENTO_VC_FRECUENTES);

$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);
