<?php

$this->assign("item_menu", "consults");

//Id del paciente que el médico elije
if ($this->request["mis_registros_consultas_medicas"] == 1) {
    $idpaciente = $this->request["idpaciente"];
} else {
    if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
        $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
    } else {
        $idpaciente = $this->request["idpaciente"];
    }
}

if ((int) $idpaciente > 0) {

    $ManagerMedico = $this->getManager("ManagerMedico");
    $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
    if ($paciente) {
        $this->assign("paciente", $paciente);
    }
}

$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
if ($this->request["mis_registros_consultas_medicas"] != 1) {

    //Obtengo los tags INputs

    $tags = $ManagerPerfilSaludConsulta->getInfoTags($idpaciente);
    if ($tags) {
        $this->assign("tags", $tags);
    }

    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
    $this->assign("info_menu_paciente", $info_menu);


    $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
}

$consulta = $ManagerPerfilSaludConsulta->getConsultaCompleta($this->request["idperfilSaludConsulta"]);

//obtenemos si la consulta le pertenece a un paciente del medico en session
$this->assign("consulta", $consulta);

if ($consulta["medico_idmedico"] != $_SESSION[URL_ROOT]["medico"]['logged_account']["medico"]["idmedico"]) {
    $this->assign("otro_profesional", 1);
}

/* if ($consulta["medico_idmedico"]==$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]) {

  } else {
  //el paciente no le pertenece
  $this->assign("no_medico_frecuente", 1);
  } */

// <-- LOG
$log["data"] = "consultation data";
$log["page"] = "Medical records";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See consultation detail";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--