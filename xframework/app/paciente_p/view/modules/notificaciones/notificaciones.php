<?php

  
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);
    
    // <-- LOG
    $log["data"] = "Date, time, Profesionnal, notification type, status";
    $log["page"] = "Notifications";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Panel";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--