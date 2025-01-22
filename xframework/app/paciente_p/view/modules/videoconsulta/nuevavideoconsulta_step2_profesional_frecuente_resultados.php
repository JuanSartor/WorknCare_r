<?php

$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$ManagerMedico = $this->getManager("ManagerMedico");
//  $ManagerMedico->print_r($request_anterior);
$request_anterior["current_page"] = $this->request["current_page"];
if ($this->request["do_reset"] == 1) {
    $request_anterior["do_reset"] = $this->request["do_reset"];
}
$ManagerFiltrosBusquedaVideoConsulta = $this->getManager("ManagerFiltrosBusquedaVideoConsulta");
//obtengo los filtros con los que se creo la VC
$filtro = $ManagerFiltrosBusquedaVideoConsulta->getByField("videoconsulta_idvideoconsulta", $this->request["idvideoconsulta"]);
$filtro["nueva_consulta"] = 1;
$filtro["tipo"] = "videoconsulta";
$this->assign("filtro", $filtro);


if ((int) $filtro["especialidad_idespecialidad"] > 0) {
    $this->assign("especialidad", $this->getManager("ManagerEspecialidades")->get($filtro["especialidad_idespecialidad"]));
}


if ((int) $filtro["idprograma_categoria"] > 0) {
    $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($filtro["idprograma_categoria"]);
    $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
    $this->assign("programa_categoria", $programa_categoria);
    $this->assign("programa_salud", $programa_salud);
}

if ((int) $filtro["idprograma_salud"] > 0) {
    $programa_salud = $this->getManager("ManagerProgramaSalud")->get($filtro["idprograma_salud"]);
    $this->assign("programa_salud", $programa_salud);
}


if (is_array($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"])) {
    unset($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"]);
}

$cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
$this->assign("cuenta_paciente", $cuenta_paciente);

//incluimos el modulo del listado de profesionales
$_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"] = $filtro;
$this->includeSubmodule('busqueda', 'busqueda_profesional_resultado_modulo');
