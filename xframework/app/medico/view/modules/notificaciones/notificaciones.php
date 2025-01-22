<?php
    /*
    $ManagerSolicitudRenovacionPerfilSaludMedicamento = $this->getManager("ManagerSolicitudRenovacionPerfilSaludMedicamento");
    $list_solicitud = $ManagerSolicitudRenovacionPerfilSaludMedicamento->getListSolicitudFromMedico();
    if ($list_solicitud && count($list_solicitud) > 0) {
        $this->assign("list_solicitud", $list_solicitud);
    }

    $ManagerTurno = $this->getManager("ManagerTurno");
    $list_turno = $ManagerTurno->getListNotificacionesMedico();
    if ($list_turno && count($list_turno) > 0) {
        $this->assign("list_turnos", $list_turno);
    }


    $ManagerMedicoCompartirEstudio = $this->getManager("ManagerMedicoCompartirEstudio");
    $list_estudio = $ManagerMedicoCompartirEstudio->getNotificacionesMedico();

    if ($list_estudio && count($list_estudio) > 0) {
        $this->assign("list_estudios", $list_estudio);
    }

    $ManagerNotificacionSistemaMedico = $this->getManager("ManagerNotificacionSistemaMedico");
    $list_notificaciones_sistema = $ManagerNotificacionSistemaMedico->getListNotificacionesMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
    if ($list_notificaciones_sistema && count($list_notificaciones_sistema) > 0) {
        $this->assign("list_notificaciones_sistema", $list_notificaciones_sistema);
    }*/

    $ManagerMedico = $this->getManager("ManagerMedico");
    $this->assign("info_menu", $ManagerMedico->getInfoMenu($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));
    
    // <-- LOG
    $log["data"] = "Date, time, Profesionnal, notification type, status";
    $log["page"] = "Notifications";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See status";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--