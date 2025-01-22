<?php

$this->assign("item_menu", "vaccine");

//Paciente que se encuentra en el array de SESSION de header paciente
if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
    $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
}else{
      $idpaciente=$this->request["idpaciente"];
  }
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->get($idpaciente);
$profesional_frecuente_cabecera = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$idpaciente, 1]);
if ($profesional_frecuente_cabecera) {
    $paciente["medico_cabecera"] = $this->getManager("ManagerMedico")->get($profesional_frecuente_cabecera["medico_idmedico"]);
}
$this->assign("paciente", $paciente);

$ManagerVacuna = $this->getManager("ManagerVacuna");
$listado = $ManagerVacuna->getInformationTable($idpaciente);

$this->assign("listado", $listado);

//Obtengo los tags INputs
$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
$tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
if ($tags) {
    $this->assign("tags", $tags);
}

$estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
$this->assign("estadoTablero", $estadoTablero);



$info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
$this->assign("info_menu_paciente", $info_menu);
