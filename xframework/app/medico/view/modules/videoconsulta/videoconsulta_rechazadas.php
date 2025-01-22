<?php

    //actualizamos el contador de notificaciones
    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
    $ManagerVideoConsulta->setNotificacionesLeidasMedico(["idestadoVideoConsulta" => 3]);

    $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
    $this->assign("notificacion_general", $cantidad_consulta["notificacion_general"]);

    $this->assign("cantidad_consulta", $cantidad_consulta);

    //Consulta Rechazada
    $this->request["idestadoVideoConsulta"] = 3;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

    $idpaginate = "listado_paginado_videoconsultas_rechazadas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_videoconsultas_rechazadas", $listado);
    }

    // <-- LOG
    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, choice confirmation consultation last 12 months, consultation fee";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation DECLINED";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <-- 