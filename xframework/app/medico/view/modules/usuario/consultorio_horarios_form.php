<?php

  /**
   *  Formulario de creación/edición de turno de para la agenda de medico
   *
   * */

  $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");

  //$this->assign("dia_iddia", $this->request["dia_iddia"]);

  $idconsultorio = $this->request["id"];

  if (isset($idconsultorio) && $idconsultorio != "") {

      $managerConsultorio = $this->getManager("ManagerConsultorio");
      $consultorio = $managerConsultorio->get($idconsultorio);
      $this->assign("consultorio", $consultorio);
  }

  $this->assign("horas_minutos", $ManagerConfiguracionAgenda->getComboHorarioMinutos($this->request["id"]));


  /**
   *  Pantalla de configuracion de turnos para los dias de la semana
   *
   * */
  
  $this->assign("horarios", $ManagerConfiguracionAgenda->getTodosLosHorarios($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"],$idconsultorio));

  $this->assign("combo_duracion_turnos", $this->getManager("ManagerPreferencia")->getComboDuracionTurnos());

  


  