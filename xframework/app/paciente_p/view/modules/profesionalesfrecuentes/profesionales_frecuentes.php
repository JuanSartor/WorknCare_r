<?php

	//Paciente que se encuentra en el array de SESSION de header paciente
	$ManagerPaciente = $this->getManager("ManagerPaciente");
	$paciente = $ManagerPaciente->getPacienteXHeader();
	$this->assign("paciente", $paciente);

    // <-- LOG
    $log["data"] = "List of Frequent Professionals";
    $log["page"] = "Frequent Professionals";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Frequent Profesionals";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--