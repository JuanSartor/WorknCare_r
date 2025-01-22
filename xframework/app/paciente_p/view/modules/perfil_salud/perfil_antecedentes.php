<?php

    $this->assign("item_menu", "dna");


    // Debo instanciar el paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $paciente = $ManagerPaciente->getPacienteXHeader();
    
    $this->assign("paciente", $paciente);   

    //Obtengo el perfil de antecedentes
    $ManagerPerfilSaludAntecedentes = $this->getManager("ManagerPerfilSaludAntecedentes");
    $record = $ManagerPerfilSaludAntecedentes->getByField("paciente_idpaciente", $paciente["idpaciente"]);
    $this->assign("record", $record);


    //Manager del tipo familiar
    $ManagerTipoFamiliar = $this->getManager("ManagerTipoFamiliar");
    $this->assign("list_tipo_familiar", $ManagerTipoFamiliar->getList());

    //Listado de los tipos de patologías
    $ManagerTipoPatologia = $this->getManager("ManagerTipoPatologia");
    $this->assign("list_tipo_patologia", $ManagerTipoPatologia->getList());

    //Obtención de los tags_inputs
    $ManagerAntecedentesPatologiaFamiliar = $this->getManager("ManagerAntecedentesPatologiaFamiliar");
    $tags_inputs = $ManagerAntecedentesPatologiaFamiliar->getTagsInputs($paciente["idpaciente"]);
    $this->assign("perfiles_antecedentes", $tags_inputs);

    //Obtención de los combos para los grupos de factores sanguíneos
    $ManagerGrupoFactorSanguineo = $this->getManager("ManagerGrupoFactorSanguineo");
    $this->assign("combo_grupo_sanguineo", $ManagerGrupoFactorSanguineo->getCombo());
  
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
 
    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);
    
    // <-- LOG
    $log["data"] = "Register Family issues";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--