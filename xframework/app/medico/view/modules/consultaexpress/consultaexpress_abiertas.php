<?php

    //Consulta Abierta
    $this->request["idestadoConsultaExpress"] = 2;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    $this->assign("idmedico", $idmedico);
    
    $idpaginate = "listado_paginado_consultas_abiertas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");

    $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_consultas_abiertas", $listado);
    }

    $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);

    // <-- LOG
    $log["data"] = "text doctor, audio doctor,date, time, patient user account, patient consulting, reason for consultation, text patient, picture patient";
    $log["page"] = "Consultation Express";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Consultation Express ONGOING";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--