<?php

    $this->assign("item_menu", "patology");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    //Obtengo el perfil de antecedentes
    $ManagerPerfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes");
    $record = $ManagerPerfilSaludAntecedentes->getByField("paciente_idpaciente", $paciente["idpaciente"]);
    $this->assign("record", $record);


    //Antecedentes personales
    $ManagerAntecedentesPersonales = $this->getManager("ManagerAntecedentesPersonales");
    $this->assign("antecedente", $ManagerAntecedentesPersonales->getByField("paciente_idpaciente", $paciente["idpaciente"]));

    //Patologías actuales
    $ManagerPatologiasActuales = $this->getManager("ManagerPatologiasActuales");
    $this->assign("patologias_actuales", $ManagerPatologiasActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));

    //Enfermedades actuales y tipos de enfermedad
    $ManagerEnfermedadesActuales = $this->getManager("ManagerEnfermedadesActuales");
    $this->assign("enfermedad_actual", $ManagerEnfermedadesActuales->getByField("paciente_idpaciente", $paciente["idpaciente"]));
    
    //Tags Inputs
    $tags = $ManagerEnfermedadesActuales->getTagsInputs($paciente["idpaciente"]);
    
    $this->assign("perfiles_patologias", $tags);

    $ManagerEnfermedad = $this->getManager("ManagerEnfermedad");
    $this->assign("combo_enfermedad", $ManagerEnfermedad->getCombo());
  
    //$listado = $ManagerEnfermedad->getListadoFrontEnd($paciente["idpaciente"]);
    //$this->assign("enfermedades", $listado);
  
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
   
    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);


    // <-- LOG
    $log["data"] = "Register Medical issues";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--