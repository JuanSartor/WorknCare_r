<?php

$ManagerTurno = $this->getManager("ManagerTurno");
//$ManagerTurno->debug();
$fecha = $this->request["fecha"];
if ($fecha == "") {
    $fecha = date('d/m/Y');
}

list($d, $m, $y) = preg_split("[/]", $fecha);

//echo $fecha;
//Si requiere el siguiente día
if (isset($this->request["next"]) && $this->request["next"] != "") {
    $fecha_sql = "{$y}-{$m}-{$d}";
    $fecha = date('d/m/Y', strtotime('+1 day', strtotime($fecha_sql)));
    list($d, $m, $y) = preg_split("[/]", $fecha);
}
//Si requiere el día anterior
elseif (isset($this->request["previous"]) && $this->request["previous"] != "") {
    $fecha_sql = "{$y}-{$m}-{$d}";
    $fecha = date('d/m/Y', strtotime('-1 day', strtotime($fecha_sql)));
    list($d, $m, $y) = preg_split("[/]", $fecha);
}

$this->assign("dia", $d);
$this->assign("anio", $y);
$this->assign("dia_agenda", $fecha);

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

//obtenemos los consultorios del medico
$managerConsultorio = $this->getManager("ManagerConsultorio");
$listado_consultorios = $managerConsultorio->getListconsultorioMedico($idmedico);
$this->assign("consultorio_list", $listado_consultorios);

//El formato de la fecha recibida es dd/mm/aaaa
list($d, $m, $y) = preg_split("[/]", $fecha);

$fecha_format_arg = date('d/m/Y', mktime(0, 0, 0, $m, $d, $y));

if (isset($this->request["idconsultorio"]) && $this->request["idconsultorio"] != "") {
    $idconsultorio = $this->request["idconsultorio"];
} else {
    $idconsultorio = $managerConsultorio->getConsultorioPorDefecto($idmedico)["idconsultorio"];
}
$this->assign("idconsultorio", $idconsultorio);



//veriifamos si el dia del turno esta en el periodo de vacaciones cargado por el medico
$vacaciones_medico = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones($idmedico);

if ($vacaciones_medico) {
    foreach ($vacaciones_medico as $periodo_vacaciones) {
        $fecha_turno = "{$y}-{$m}-{$d}";
        if (strtotime($fecha_turno) >= strtotime($periodo_vacaciones["desde"]) && strtotime($fecha_turno) <= strtotime($periodo_vacaciones["hasta"])) {
            $this->assign("vacaciones", 1);
           
            break;
        }
    }
}
//obtenemos la agenda diaria del medico 
$listado_turnos_diarios = $ManagerTurno->getAgendaDiaMedico($fecha_format_arg, $idconsultorio);

//obtenemos la posicion del turno en la que cambia la configuracion de agenda de turnos
//cuando los turnos pertenecen a distinta configuracion agenda, puede haber un tiempo libre entre ellas
if (count($listado_turnos_diarios["posicion_cambio_config_agenda"]) > 0) {
    $this->assign("posicion_cambio_config_agenda", $listado_turnos_diarios["posicion_cambio_config_agenda"]);
    //  print_r($listado_turnos_diarios["posicion_cambio_config_agenda"]);
    unset($listado_turnos_diarios["posicion_cambio_config_agenda"]);
}
$this->assign("listado_turnos_diarios", $listado_turnos_diarios);


$agenda_definida = $ManagerTurno->isAgendaDefinida($idconsultorio);

$this->assign("agenda_definida", $agenda_definida);

/**
 * Fechas
 */
$nombre_mes = getNombreMes($m);

$this->assign("nombre_mes", $nombre_mes);

$dia = getNumeroDiaSemana($d, $m, $y);


$nombre_dia = getNombreCortoDia((int) $dia + 1);
$this->assign("nombre_dia", $nombre_dia);


$fecha_format = date("d/m/Y", mktime(0, 0, 0, $m, $d, $y));

$this->assign("titulo_resumen", $fecha_format);


//obtenemos la cantidad de turnos por consultorio
$listado_datos_consultorios = $managerConsultorio->getDatosTurnosXConsultorio($fecha_format_arg, 1);

if ($listado_datos_consultorios) {
    $this->assign("datos_consultorios", $listado_datos_consultorios);
}

$nextTurno = $ManagerTurno->getNextTurnoDisponble($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"], $fecha_format, $idconsultorio);

$this->assign("nextTurno", $nextTurno);

// <-- LOG
$log["data"] = "medical appointements with status";
$log["page"] = "Agenda";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See agenda";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--