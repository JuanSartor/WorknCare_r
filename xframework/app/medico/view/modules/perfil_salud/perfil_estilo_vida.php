<?php

$this->assign("item_menu", "lifestyle");

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

//Obtengo los tags INputs
$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
$tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
if ($tags) {
    $this->assign("tags", $tags);
}


$ManagerPerfilSaludEstiloVida = $this->getManager("ManagerPerfilSaludEstiloVida");
$record = $ManagerPerfilSaludEstiloVida->getByField("paciente_idpaciente", $paciente["idpaciente"]);
if ($record) {

    $this->assign("record", $record);
} else {
    //Si no hay estilo de vida, lo creo por defecto..

    $rdo = $ManagerPerfilSaludEstiloVida->process(array("paciente_idpaciente" => $paciente["idpaciente"]));

    if (!$rdo) {
        //Si hay un problema al crear el estilo de vida, tengo que poner paciente en false así no se muestra el módulo
        $this->assign("paciente", false);
    } else {

        $record = $ManagerPerfilSaludEstiloVida->getByField("paciente_idpaciente", $paciente["idpaciente"]);
        $this->assign("record", $record);
    }
}

$estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
$this->assign("estadoTablero", $estadoTablero);


$info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
$this->assign("info_menu_paciente", $info_menu);
