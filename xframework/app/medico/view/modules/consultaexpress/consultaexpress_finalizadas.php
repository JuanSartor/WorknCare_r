<?php

    //actualizamos el contador de notificaciones
    $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
    
    $ManagerConsultaExpress->setNotificacionesLeidasMedico(["idestadoConsultaExpress" => 4]);

    $this->request["idestadoConsultaExpress"] = 4;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

    $idpaginate = "listado_paginado_consultas_finalizadas_{$idmedico}";
    $this->assign("idpaginate", $idpaginate);

    $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_consultas_finalizadas", $listado);        
    }  
    
    $this->request["idestadoConsultaExpress"] = 8;
    $idpaginate2 = "listado_consultas_pendientes_finalizacion{$idmedico}";
    $this->assign("idpaginate2", $idpaginate2);
     $listado_pendientes_finalizacion = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressMedico($this->request, $idpaginate2);

    if (count($listado_pendientes_finalizacion["rows"]) > 0) {
        $this->assign("listado_consultas_pendientes_finalizacion", $listado_pendientes_finalizacion);
        
    }
    //asignamos los filtro de la busqueda si vienen seteados
    if($this->request["filtro_inicio"]!=""){
        
        $this->assign("filtro_inicio",$this->request["filtro_inicio"]);
    }
    if($this->request["filtro_fin"]!=""){
        $this->assign("filtro_fin",$this->request["filtro_fin"]);
    }

    $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);

    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Consultation Express";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Consultation Express CONCLUSION";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--