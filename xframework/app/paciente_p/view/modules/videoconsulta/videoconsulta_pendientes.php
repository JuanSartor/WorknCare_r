<?php

  
    //videoconsulta Pendiente
    $this->request["idestadoVideoConsulta"] = 1;

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);
    
    $idpaginate = "listado_paginado_videoconsultas_pendientes_{$paciente["idpaciente"]}";
    $this->assign("idpaginate", $idpaginate);

    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

    $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasPaciente($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_videoconsultas_pendientes", $listado);

        //print_r($listado);
    }

    $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);
  
    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation request SENT";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--
  