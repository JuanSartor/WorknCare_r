<?php

//Consulta Pendiente
$this->request["idestadoConsultaExpress"] = 1;

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
$this->assign("idmedico", $idmedico);

$idpaginate = "listado_paginado_consultas_pendientes_$idmedico";
$this->assign("idpaginate", $idpaginate);

$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_consultas_pendientes", $listado);
}

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

// <-- LOG
$log["data"] = "-";
$log["page"] = "Consultation Express";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Consultation Express RECEIVED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--