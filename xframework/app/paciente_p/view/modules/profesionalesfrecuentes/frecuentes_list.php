<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
//obtenermos si es paciente empresa y cuantas consultas tiene
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $this->assign("paciente_empresa", $paciente_empresa);
    $this->assign("plan_contratado", $plan_contratado);
    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];

    $this->request["paciente_empresa"] = $paciente_empresa;
}
$this->assign("paciente", $paciente);


$paginate = "profesionales_frecuentes_list";

$this->assign("idpaginate", $paginate);

//$ManagerPaciente->debug();
$medicos_list = $ManagerPaciente->getMedicosFrecuentesList($this->request, $paginate);


if ($medicos_list) {
    $this->assign("medicos_list", $medicos_list);
}

  
  
