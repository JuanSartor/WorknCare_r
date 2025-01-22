<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

//obtenemos la consulta express
$VideoConsulta = $this->getManager("ManagerVideoConsulta")->getVideoConsultaBorrador($paciente["idpaciente"]);
$this->assign("VideoConsulta", $VideoConsulta);

//si la consulta es de prefesionales en la red verificamos si ya se han creado los filtros de busqueda
if ($VideoConsulta["consulta_step"] == "2" && $VideoConsulta["tipo_consulta"] == "0") {
    $filtro = $this->getManager("ManagerFiltrosBusquedaVideoConsulta")->getByField("videoconsulta_idvideoconsulta", $VideoConsulta["idvideoconsulta"]);

    $this->assign("filtro", $filtro);
}

$cantidad_consulta = $this->getManager("ManagerVideoConsulta")->getCantidadVideoConsultasPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);

