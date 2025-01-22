<?php

/**
 * Módulo que va a cargar los datos de la agenda semanal.
 * Recibirá:
 * $this->request["fecha"]
 * $this->request["next"]
 * $this->request["previous"]
 */
$fecha = $this->request["fecha"];


if ($fecha == "") {
    $fecha = date('d/m/Y');
}

$fecha_request = $fecha;
list($d, $m, $y) = preg_split("[/]", $fecha);

/**
 * Fechas
 */


//Si requiere la semana siguiente
if (isset($this->request["next"]) && $this->request["next"] != "") {
    $fecha = date('d/m/Y', strtotime('+1 week', mktime(0, 0, 0, $m, $d, $y)));
}
//Si requiere el día anterior
elseif (isset($this->request["previous"]) && $this->request["previous"] != "") {
    $fecha = date('d/m/Y', strtotime('-1 week', mktime(0, 0, 0, $m, $d, $y)));
}


$this->assign("dia_semana", $fecha);
$this->assign("dia_agenda", $fecha);

list($d, $m, $y) = preg_split("[/]", $fecha);

$dia = date("w", mktime(0, 0, 0, $m, $d, $y));

//primer dia semana-INICIO
if ($dia == "1") {
    $fecha_inicio_semana = date("d/m/Y", mktime(0, 0, 0, $m, $d, $y));
} else {
    $fecha_inicio_semana = date('d/m/Y', strtotime('previous Monday', mktime(0, 0, 0, $m, $d, $y)));
}


$this->assign("fecha_inicio_semana", $fecha_inicio_semana);

list($d1, $m1, $y1) = preg_split("[/]", $fecha_inicio_semana);
$this->assign("dia_inicio",$d1);
$nombre_mes_inicio=  getNombreCortoMes($m1);//obengo el mes por si son distintos
$this->assign("nombre_mes_inicio", $nombre_mes_inicio);


$nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $m1, $d1, $y1)));

$this->assign("nombre_mes", $nombre_mes);


//ultimo dia semana-FIN
if ($dia == "0") {
    $fecha_fin_semana = date("d/m/Y", mktime(0, 0, 0, $m, $d, $y));
} else {
    $fecha_fin_semana = date('d/m/Y', strtotime('Sunday', mktime(0, 0, 0, $m, $d, $y)));
}





$this->assign("fecha_fin_semana", $fecha_fin_semana);
list($d2, $m2, $y2) = preg_split("[/]", $fecha_fin_semana);
$nombre_mes_fin=  getNombreCortoMes($m2);//obengo el mes por si son distintos
$this->assign("nombre_mes_fin", $nombre_mes_fin);

$this->assign("dia_fin",$d2);

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

$managerConsultorio = $this->getManager("ManagerConsultorio");
$this->assign("consultorio_list", $managerConsultorio->getListconsultorioMedico($idmedico));

$dias = array("Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche");
$fechas_semana = array();
for ($i = 0; $i < 7; $i++) {
    list($d_is,$m_is, $y_is) = preg_split("[/]", $fecha_inicio_semana);
    if ($i > 0) {
        $fecha_inicio_semana = date('d/m/Y', strtotime('+1 day', mktime(0, 0, 0, $m_is, $d_is, $y_is)));
        list($d_is,$m_is, $y_is) = preg_split("[/]", $fecha_inicio_semana);
        $fechas_semana[$i]["numero_dia"] = $d_is;
    } else {
        $fechas_semana[$i]["numero_dia"] = $d_is;
    }

    $fechas_semana[$i]["dia"] = $dias[$i];
}


$this->assign("fechas_semana", $fechas_semana);

$ManagerTurno = $this->getManager("ManagerTurno");


$fecha_format_arg = date("d/m/Y", mktime(0, 0, 0, $m, $d, $y));

//selecciono el consultorio del que se van mostrar los turnos
if (isset($this->request["idconsultorio"]) && $this->request["idconsultorio"] != "") {
    $idconsultorio = $this->request["idconsultorio"];
} else {
    $idconsultorio = $managerConsultorio->getConsultorioPorDefecto($idmedico)["idconsultorio"];
}
$this->assign("idconsultorio", $idconsultorio);
//obtengo el listado de turnos de la semana
$list_agenda_semanal = $ManagerTurno->getAgendaSemanaMedico($fecha_format_arg, $idconsultorio);


if ($list_agenda_semanal) {
    $this->assign("list_agenda_semanal", $list_agenda_semanal);

   
}
//obtenemos la cantidad de turnos por consultorio
 $listado_datos_consultorios = $managerConsultorio->getDatosTurnosXConsultorio($fecha_format_arg,2);
  if ($listado_datos_consultorios) {
      $this->assign("datos_consultorios", $listado_datos_consultorios);
   
  }

  $this->assign("titulo_resumen", "semanal");
$agenda_definida = $ManagerTurno->isAgendaDefinida($idconsultorio);

$this->assign("agenda_definida", $agenda_definida);


  
  