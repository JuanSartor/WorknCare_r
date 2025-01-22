<?php

    //actualizamos el contador de notificaciones
    $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
    $ManagerConsultaExpress->setNotificacionesLeidasMedico(["idestadoConsultaExpress" => 3]);

    $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
    $this->assign("notificacion_general", $cantidad_consulta["notificacion_general"]);

    $this->assign("cantidad_consulta", $cantidad_consulta);

    //Consulta Rechazada
    $this->request["idestadoConsultaExpress"] = 3;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

    $idpaginate = "listado_paginado_consultas_rechazadas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_consultas_rechazadas", $listado);
    }

    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Consultation Express";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Consultation Express DECLINED";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--  