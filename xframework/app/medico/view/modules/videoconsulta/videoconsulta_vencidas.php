<?php

    //actualizamos el contador de notificaciones
    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
    $ManagerVideoConsulta->setNotificacionesLeidasMedico(["idestadoVideoConsulta" => 5]);
    
      //Consulta Abierta
    $this->request["idestadoVideoConsulta"] = 5;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    $this->assign("idmedico", $idmedico);
    
    $idpaginate = "listado_paginado_videoconsultas_abiertas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_videoconsultas_vencidas", $listado);
    }

    $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);
    
    // <-- LOG
    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation EXPIRED";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <-- 