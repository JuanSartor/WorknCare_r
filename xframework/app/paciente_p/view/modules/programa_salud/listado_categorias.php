<?php

$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);
if (isset($this->request["idprograma_salud"]) && $this->request["idprograma_salud"] != "") {
    $programa = $this->getManager("ManagerProgramaSalud")->get($this->request["idprograma_salud"]);
    $this->assign("programa", $programa);
    $listado_categorias = $this->getManager("ManagerProgramaSaludCategoria")->getListadoCategorias($this->request["idprograma_salud"]);
    $this->assign("listado_categorias", $listado_categorias);
}

$ManagerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
$paciente_empresa = $ManagerPacienteEmpresa->getByField("paciente_idpaciente", $paciente["idpaciente"]);
$this->assign("paciente_empresa", $paciente_empresa);
