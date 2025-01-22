<?php

    $this->assign("item_menu", "lifestyle");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);


    $ManagerPerfilSaludEstiloVida = $this->getManager("ManagerPerfilSaludEstiloVida");
    $record = $ManagerPerfilSaludEstiloVida->getByField("paciente_idpaciente", $paciente["idpaciente"]);
    if ($record) {
        
        $this->assign("record", $record);
    }else{
        //Si no hay estilo de vida, lo creo por defecto..
        
        $rdo = $ManagerPerfilSaludEstiloVida->process(array("paciente_idpaciente" => $paciente["idpaciente"]));
        
        if(!$rdo){
            //Si hay un problema al crear el estilo de vida, tengo que poner paciente en false así no se muestra el módulo
            $this->assign("paciente", false);
        }else{
            
            $record = $ManagerPerfilSaludEstiloVida->getByField("paciente_idpaciente", $paciente["idpaciente"]);
            $this->assign("record", $record);
        }
    }
    /*$info_estilo_vida = $ManagerPerfilSaludEstiloVida->getDatosCard($paciente["idpaciente"]);
    $this->assign("info_estilo_vida", $info_estilo_vida);*/
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
 
    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register Lifestyle";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--
  
