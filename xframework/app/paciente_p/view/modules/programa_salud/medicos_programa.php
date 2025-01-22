<?php
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

if (isset($this->request["idprograma_categoria"]) && $this->request["idprograma_categoria"] != "") {
    $categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($this->request["idprograma_categoria"]);
    $this->assign("categoria", $categoria);

    $programa = $this->getManager("ManagerProgramaSalud")->get($categoria["programa_salud_idprograma_salud"]);
    $this->assign("programa", $programa);

    $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"] = $this->request;
}
