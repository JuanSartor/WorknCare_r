<?php

$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
//proximos turnos 
$ManagerTurno = $this->getManager("ManagerTurno");

$listado_turnos = $ManagerTurno->getListadoSiguientesTurnosHome($paciente["idpaciente"]);

$this->assign("listado_turnos", $listado_turnos);


