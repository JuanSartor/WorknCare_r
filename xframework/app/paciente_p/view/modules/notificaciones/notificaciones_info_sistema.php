<?php

$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();


$idpaciente = $paciente["idpaciente"];

$ManagerNotificacion = $this->getManager("ManagerNotificacion");
$paginate = "list_info_sistema";
$this->assign("idpaginate", $paginate . "_" . $idpaciente);

$listado = $ManagerNotificacion->getListadoPaginadoInfoSistemaPaciente($this->request, $paginate . "_" . $idpaciente);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_notificaciones", $listado);
}