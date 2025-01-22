<?php

$this->start();
$ManagerTurno=$this->getManager("ManagerTurno");

$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$ManagerTurno->reprogramar_turno($paciente["idpaciente"],$this->request["idturno"],$this->request["reprogramar"]);
$this->finish($ManagerTurno->getMsg());
