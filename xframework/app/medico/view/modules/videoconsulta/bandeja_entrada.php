<?php


    $ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
   
    $cantidad_consulta=$ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();

    $this->assign("cantidad_consulta",$cantidad_consulta); 

    $this->includeSubmodule("videoconsulta","videoconsulta_interrumpidas");
    $this->includeSubmodule("videoconsulta","videoconsulta_pendientes_finalizacion");

    // <-- LOG
    $log["data"] = "data conclusion created, picture, prescription attached";
    $log["page"] = "Video Consultation";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Video Consultation CONCLUSION";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <-- 