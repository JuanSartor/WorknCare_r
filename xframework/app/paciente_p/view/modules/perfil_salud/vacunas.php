<?php

    $this->assign("item_menu", "vaccine");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    $ManagerVacuna = $this->getManager("ManagerVacuna");

    $listado = $ManagerVacuna->getInformationTable($paciente["idpaciente"]);
    $this->assign("listado", $listado);

    $listado_vacunas_descripcion = $ManagerVacuna->getListadoVacunas();

    $this->assign("listado_vacunas_descripcion", $listado_vacunas_descripcion);

    $ManagerVacunaEdad = $this->getManager("ManagerVacunaEdad");
    $listado_vacuna_edad = $ManagerVacunaEdad->getListVacunaEdad();
    $this->assign("listado_vacuna_edad", $listado_vacuna_edad);

    $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register Vaccinations & Controls";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--
