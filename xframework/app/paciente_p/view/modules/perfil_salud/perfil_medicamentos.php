<?php

    $this->assign("item_menu", "medicine");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");

    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");
    $this->assign("combo_especialidades", $ManagerEspecialidades->getCombo());

    $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
    $this->assign("combo_tipo_toma_medicamento", $ManagerTipoTomaMedicamentos->getCombo());

    $combo_profesionales_frecuentes=$ManagerPaciente->getComboProfesionalesFrecuentes($paciente["idpaciente"]);
    $this->assign("combo_profesionales_frecuentes",$combo_profesionales_frecuentes );
    
    $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
    $listado_medicacion_actual = $ManagerPerfilSaludMedicamento->getListMedicacionActual(array("paciente_idpaciente" => $paciente["idpaciente"]));
    if ($listado_medicacion_actual) {
        $this->assign("listado_medicacion_actual", $listado_medicacion_actual);
    }
  
    $listado_medicacion_historica = $ManagerPerfilSaludMedicamento->getListMedicacionHistorica(array("paciente_idpaciente" => $paciente["idpaciente"]));
    if ($listado_medicacion_historica) {
        $this->assign("listado_medicacion_historica", $listado_medicacion_historica);
        
    }
  
    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
   
    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register Medication";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--