<?php

$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];
//OBtengo los consultorios del médico
$managerConsultorio = $this->getManager("ManagerConsultorio");

$list_consultorios = $managerConsultorio->getListconsultorioMedico($idmedico,true);


$this->assign("consultorios", $list_consultorios);
$consultorio_virtual = $managerConsultorio->getConsultorioVirtual();
if ($consultorio_virtual) {
    $this->assign("consultorio_virtual", $consultorio_virtual);
}





