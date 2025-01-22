<?php

//Consulta Abierta
$this->request["idestadoConsultaExpress"] = 1;

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
$this->assign("idmedico", $idmedico);



$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

$CE = $ManagerConsultaExpress->get($this->request["idconsultaExpress"]);
$this->request["paciente_idpaciente"] = $CE["paciente_idpaciente"];
$consulta = $ManagerConsultaExpress->getConsultaExpressPaciente($this->request);


if (count($consulta) > 0) {

    $this->assign("consulta_pendiente", $consulta);
}

$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

$this->assign("combo_motivo_rechazo", $this->getManager("ManagerMotivoRechazo")->getCombo());
