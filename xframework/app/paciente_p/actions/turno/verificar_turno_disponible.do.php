<?php

$this->start();
$ManagerTurno=$this->getManager("ManagerTurno");
$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$ManagerTurno->turnoDisponible($paciente["paciente_idpaciente"],$this->request["idturno"]);
$this->finish($ManagerTurno->getMsg());
