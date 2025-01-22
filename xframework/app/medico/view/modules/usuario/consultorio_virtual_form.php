<?php

  if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
      $managerConsultorio = $this->getManager("ManagerConsultorio");
      $this->assign("record", $managerConsultorio->get($this->request["id"]));
  }
  
    
  $this->assign("horarios", $ManagerConfiguracionAgenda->getTodosLosHorarios($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"],$idconsultorio));
