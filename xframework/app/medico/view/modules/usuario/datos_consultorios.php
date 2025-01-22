<?php

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

$medico = $this->getManager("ManagerMedico")->get($idmedico);
$this->assign("medico", $medico);

$especialidad = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($idmedico)[0];
$this->assign("especialidad_medico", $especialidad);

//Obtengo los consultorios del médico
$managerConsultorio = $this->getManager("ManagerConsultorio");
$ManagerPreferencia = $this->getManager("ManagerPreferencia");
$list_consultorios = $managerConsultorio->getListconsultorioMedico($idmedico, true);


$this->assign("consultorios", $list_consultorios);
$consultorio_virtual = $managerConsultorio->getConsultorioVirtual();

if ($consultorio_virtual) {
    $this->assign("consultorio_virtual", $consultorio_virtual);
}

//obtenemos la direccion de los consultorios del medico
if ($medico["direccion_iddireccion"]) {
    $ManagerDireccion = $this->getManager("ManagerDireccion");
    $this->assign("direccion", $ManagerDireccion->get($medico["direccion_iddireccion"]));
}

//obtenemos la prefencia de tarifa del medico    
$preferencia = $ManagerPreferencia->getPreferenciaMedico($idmedico);

$this->assign("preferencia", $preferencia);

$obras_sociales = $this->getManager("ManagerObraSocialMedico")->getObrasSocialesMedico($idmedico);

$this->assign("mis_obrasSociales", $obras_sociales);
/*
  $exist = $this->getManager("ManagerMedicoPrestador")->getByFieldArray(["medico_idmedico", "prestador_idprestador"], [$idmedico, ISIC_ID]);
  if ($exist) {
  $this->assign("medico_isic", $exist["idmedico_prestador"]);
  }
 */

if ($this->request["show_tarifas"] == 1) {
    $this->assign("show_tarifas", 1);
}

// <-- LOG
$log["data"] = "Medical practice info (currently active)";
$log["page"] = "Professional information";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Medical practice";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--
// asigno el id del consutorio y una flag para indicar la accion quer realizo
$this->assign("idconsultorio", $this->request['idconsultorio']);
$this->assign("asignarhorario", $this->request['asignarhorario']);
