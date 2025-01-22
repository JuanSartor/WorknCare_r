<?php

$this->start();

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);
$ManagerPerfilSaludControlVisual=$this->getManager("ManagerPerfilSaludControlVisual");

$idperfilSaludControlVisual=$ManagerPerfilSaludControlVisual->insert(["paciente_idpaciente"=>$paciente["idpaciente"]]);
$estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);  

$this->finish($ManagerPerfilSaludControlVisual->getMsg());
