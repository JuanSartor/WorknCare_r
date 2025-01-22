<?php

    //actualizamos el contador de notificaciones
    $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
    $ManagerConsultaExpress->setNotificacionesLeidasMedico(["idestadoConsultaExpress" => 5]);
  
    //Consulta Abierta
    $this->request["idestadoConsultaExpress"] = 5;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    $this->assign("idmedico", $idmedico);
    
    $idpaginate = "listado_paginado_consultas_abiertas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_consultas_vencidas", $listado);
    }

    $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);
    
    // <-- LOG
    $log["data"] = "Patient consulting, patient consent, reason for medical appointment, comentary, file added, profesional name, specialty, date & time request, consultation fee";
    $log["page"] = "Consultation Express";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Consultation Express EXPIRED";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--