<?php

//actualizamos el contador de notificaciones
$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");


 $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
   $this->assign("paciente", $paciente);
 //Consulta Finalizadas
  $this->request["idestadoConsultaExpress"] = 3;

  
  $idpaginate = "listado_paginado_consultas_rechazadas_" . $paciente["idpaciente"];
  $this->assign("idpaginate", $idpaginate);

  

  $listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressPaciente($this->request, $idpaginate);

  if (count($listado["rows"]) > 0) {
      $this->assign("listado_consultas_rechazadas", $listado);
  }

  $cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
  $this->assign("cantidad_consulta", $cantidad_consulta);
  
 
// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express DECLINED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  