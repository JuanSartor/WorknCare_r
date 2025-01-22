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

  
  
  list($d, $m, $y) = preg_split("[/]", $fecha);
  
  
  //Si requiere el siguiente día
  if (isset($this->request["next"]) && $this->request["next"] != "") {
      $fecha = date('d/m/Y', strtotime('+1 month', mktime(0, 0, 0, $m, $d, $y)));
  }
  //Si requiere el día anterior
  elseif (isset($this->request["previous"]) && $this->request["previous"] != "") {
      $fecha = date('d/m/Y', strtotime('-1 month', mktime(0, 0, 0, $m, $d, $y)));
  }
  
  $this->assign("dia_agenda", $fecha);
  $this->assign("fecha",$fecha);

  $idmedico=$_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
  $ManagerTurno = $this->getManager("ManagerTurno");
  
  $managerConsultorio = $this->getManager("ManagerConsultorio");
  $this->assign("consultorio_list", $managerConsultorio->getListconsultorioMedico( $idmedico));

  list($d, $m, $y) = preg_split("[/]", $fecha);

  $fecha_format_arg = date('d/m/Y', mktime(0, 0, 0, $m, $d, $y)); 
  
  //nombre Mes
  $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $m, $d, $y)));

  $this->assign("nombre_mes", $nombre_mes);
  
  if (isset($this->request["idconsultorio"]) && $this->request["idconsultorio"] != "") {
      $idconsultorio = $this->request["idconsultorio"];
  
  } else {
      $idconsultorio = $managerConsultorio->getConsultorioPorDefecto($idmedico)["idconsultorio"];
  }
    $this->assign("idconsultorio", $idconsultorio);

  $list_agenda_mensual = $ManagerTurno->getAgendaMensualMedico($fecha_format_arg, $idconsultorio);
  
  $this->assign("list_agenda_mensual", $list_agenda_mensual);


  //obtenemos la cantidad de turnos por consultorio
  $listado_datos_consultorios = $managerConsultorio->getDatosTurnosXConsultorio($fecha_format_arg,3);
  if ($listado_datos_consultorios) {
      $this->assign("datos_consultorios", $listado_datos_consultorios);
        
  }
  $this->assign("titulo_resumen", $nombre_mes);
  
  $agenda_definida = $ManagerTurno->isAgendaDefinida($idconsultorio);
$this->assign("agenda_definida", $agenda_definida);

