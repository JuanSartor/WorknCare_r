<?php

$managerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");


$all_members = $managerPacienteGrupoFamiliar->getAllPacientesFamiliares($this->request);


if (count($all_members) > 0) {
    //Listado de todos los miembros de un grupo...
    $this->assign("filter_selected", "add");
    $this->assign("all_members", $all_members);
}

$managerPaciente = $this->getManager("ManagerPaciente");

$paciente = $managerPaciente->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);

$this->assign("paciente", $paciente);
$this->assign("paciente_titular", $paciente);

$this->assign("combo_relacion_grupo", $this->getManager("ManagerRelacionGrupo")->getCombo());
