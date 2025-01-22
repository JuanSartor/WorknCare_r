<?php

/*
  $ManagerMedico = $this->getManager("ManagerMedico");

  $idpaginate = "listado_mis_pacientes_" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

  if($this->request["query_str"] != ""){
  $this->assign("query_str", $this->request["query_str"]);
  }

  $paginate = SmartyPaginate::getPaginate($idpaginate);
  $this->assign("idpaginate", $paginate);
  $this->assign("from_mis_pacientes", 1);
  //$ManagerMedico->debug();
  $listado_pacientes = $ManagerMedico->getMisPacientes($this->request, $idpaginate);


  $this->assign("pacientes_list",$listado_pacientes); */

//determinamos si puede acceder al perfil de salud
$idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
$especialidad_medico = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($idmedico)[0];
$this->assign("acceso_perfil_salud", $especialidad_medico["acceso_perfil_salud"]);

// <-- LOG
$log["data"] = "Name Professionals";
$log["page"] = "My patients";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See list of connected Professionals";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--