<?php
    //actualizamos el contador de notificaciones
    $ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");

    $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
    $this->assign("paciente", $paciente);
    //Consulta Finalizadas
    $this->request["idestadoVideoConsulta"] = 4;
    
    $idpaginate = "listado_paginado_videoconsultas_finalizadas_" . $paciente["idpaciente"];
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasPaciente($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_videoconsultas_finalizadas", $listado);
    }

    $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);
  
    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation FINALIZED";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--