<?php

    $this->assign("item_menu", "surgery");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    $ManagerPerfilSaludCirugias = $this->getManager("ManagerPerfilSaludCirugias");
    $listado = $ManagerPerfilSaludCirugias->getListCirugias($paciente["idpaciente"]);
    if ($listado && count($listado) > 0) {
        $this->assign("cantidad_cirugias", count($listado));
        $this->assign("listado_cirugias", $listado);
    }else{
        $this->assign("cantidad_cirugias", 0);
    }

    $ManagerPerfilSaludProtesis = $this->getManager("ManagerPerfilSaludProtesis");
    $listado_protesis = $ManagerPerfilSaludProtesis->getListProtesis($paciente["idpaciente"]);
    if ($listado_protesis && count($listado_protesis) > 0) {
        $this->assign("listado_protesis", $listado_protesis);
        $this->assign("cantidad_protesis", count($listado_protesis));
    }else{
        $this->assign("cantidad_protesis", 0);
    }
    $cirugias_protesis=$this->getManager("ManagerPerfilSaludCirugiasProtesis")->getByField("paciente_idpaciente",$paciente["idpaciente"]);
    $this->assign("cirugias_protesis", $cirugias_protesis);
   
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register Chirurgical operations, prothese";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--