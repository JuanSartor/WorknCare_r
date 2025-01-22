<?php

  
    //Consulta Pendiente
    $this->request["idestadoVideoConsulta"] = 1;

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    $this->assign("idmedico", $idmedico);
   
    
    $idpaginate = "listado_paginado_videoconsultas_pendientes_$idmedico";
    $this->assign("idpaginate", $idpaginate);

    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

    $listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasMedico($this->request, $idpaginate);

    if (count($listado["rows"]) > 0) {
        $this->assign("listado_videoconsultas_pendientes", $listado);       
    }

    $cantidad_consulta = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
    $this->assign("cantidad_consulta", $cantidad_consulta);
 
    // <-- LOG
    $log["data"] = "-";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation request RECEIVED";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <-- 