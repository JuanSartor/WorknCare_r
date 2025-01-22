<?php
//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

// Vamos a obtener la dirección de donde venimos y hacia donde vamos. El "de donde" lo usamos para volver y el "hacia" lo usamos para redireccionar si está OK
//print_r($_SERVER);

$this->assign("HTTP_REFERER", $_SERVER["HTTP_REFERER"]);

