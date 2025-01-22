<?php

    $ManagerPaciente = $this->getManager("ManagerPaciente");

    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    $this->assign("idpaciente", $paciente["idpaciente"]);
    
    $ManagerPacienteTablero = $this->getManager("ManagerPacienteTablero");
    $tablero_list = $ManagerPacienteTablero->getListPacienteTablero($paciente["idpaciente"]);
    if ($tablero_list && count($tablero_list) > 0) {
        $this->assign("tablero_list", $tablero_list);
    }
  
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "See information panel Health Profile";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--