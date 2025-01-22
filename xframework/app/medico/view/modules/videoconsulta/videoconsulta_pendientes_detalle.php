<?php

//Consulta Pendiente
$this->request["idestadoVideoConsulta"] = 1;

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
$this->assign("idmedico", $idmedico);



$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$VC = $ManagerVideoConsulta->get($this->request["idvideoconsulta"]);
$this->request["paciente_idpaciente"] = $VC["paciente_idpaciente"];
$consulta = $ManagerVideoConsulta->getVideoConsultaPaciente($this->request);

if (count($consulta) > 0) {

    $this->assign("videoconsulta_pendiente", $consulta);
}



$cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

$aceptar_consulta_rangos = $ManagerVideoConsulta->getRangosAceptarConsulta();
$this->assign("aceptar_consulta_rangos", $aceptar_consulta_rangos);

$this->assign("combo_motivo_rechazo", $this->getManager("ManagerMotivoRechazo")->getCombo());
