<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXSelectMedico($this->request["idpaciente"]);
$this->assign("paciente", $paciente);





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

