<?php

if ($header_paciente["filter_selected"] == "self") {
    $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
} else {
    $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["header_paciente"]["filter_selected"];
}

$ManagerPaciente = $this->getManager("ManagerPaciente");

$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);


$medico_cabecera = $ManagerPaciente->getMedicoCabecera($paciente["idpaciente"]);
$this->assign("medico_cabecera", $medico_cabecera);

//verificamos si es medico de cabecera
$prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
if ($prof_frecuente) {
    $this->assign("posee_medico_cabecera", "1");
}