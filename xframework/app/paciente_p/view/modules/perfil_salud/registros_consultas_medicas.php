<?php

    $this->assign("item_menu", "consults");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");

    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);
    $idpaciente=$paciente["idpaciente"];
  
    $ConsultaExpressPermitida = $this->getManager("ManagerPaciente")->isPermitidoConsultaExpress($idpaciente);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

  
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    // <-- LOG
    $log["data"] = "Register List of consultations";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--