<?php

//Consulta Pendiente
$this->request["idestadoVideoConsulta"] = 2;

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
$this->assign("idmedico", $idmedico);

$idpaginate = "listado_paginado_videoconsultas_espera_$idmedico";
$this->assign("idpaginate", $idpaginate);

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
//listado de consultas abiertas en espera
$listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_videoconsultas_espera", $listado);
}

$this->assign("combo_motivo_rechazo", $this->getManager("ManagerMotivoRechazo")->getCombo());

$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

$aceptar_consulta_rangos = $ManagerVideoConsulta->getRangosAceptarConsulta();
$this->assign("aceptar_consulta_rangos", $aceptar_consulta_rangos);

// <-- LOG
$log["data"] = "date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
$log["page"] = "Video Consultation";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Video Consultation accepted WAITING ROOM";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  
 