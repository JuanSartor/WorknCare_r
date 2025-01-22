<?php


    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    
    $ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
     $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);

   
    //verificamos si quedo una consulta en borrador
    $VideoConsulta=$this->getManager("ManagerVideoConsulta")->getVideoConsultaBorrador($paciente["idpaciente"]);
    $this->assign("VideoConsulta", $VideoConsulta);


    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation panel";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--