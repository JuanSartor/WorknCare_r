<?php
if (isset($this->request["idconsultorio"]) && (int) $this->request["idconsultorio"] > 0) {
     $managerConsultorio = $this->getManager("ManagerConsultorio");
      $consultorio=$managerConsultorio->get($this->request["idconsultorio"]);
      $this->assign("consultorio",$consultorio );
   
   
//obtenemos  los horarios definidos por el medico en el consultorio
    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
    $ManagerConfiguracionAgenda = $this->getManager("ManagerConfiguracionAgenda");
    $horarios = $ManagerConfiguracionAgenda->getTodosLosHorarios($idmedico, $this->request["idconsultorio"]);
    $this->assign("horarios", $horarios);

   
}