<?php

//actualizamos el contador de notificaciones
$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");


$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);
//Consulta Finalizadas
$this->request["idestadoConsultaExpress"] = 4;


$idpaginate = "listado_paginado_consultas_finalizadas_" . $paciente["idpaciente"];
$this->assign("idpaginate", $idpaginate);



$listado = $ManagerConsultaExpress->getListadoPaginadoConsultasExpressPaciente($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_consultas_finalizadas", $listado);
}

//asignamos los filtro de la busqueda si vienen seteados
if ($this->request["filtro_inicio"] != "") {

    $this->assign("filtro_inicio", $this->request["filtro_inicio"]);
}
if ($this->request["filtro_fin"] != "") {
    $this->assign("filtro_fin", $this->request["filtro_fin"]);
}


$cantidad_consulta = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
$this->assign("cantidad_consulta", $cantidad_consulta);


// <-- LOG
$log["data"] = "-";
$log["action"] = "vis"; //"val" "vis" "del"
$log["page"] = "Consultation Express";
$log["purpose"] = "See Consultation Express FINALIZED";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--  
