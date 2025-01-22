<?php

//obtenemos el paciente

$idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];

$ManagerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
$paciente_empresa = $ManagerPacienteEmpresa->getByField("paciente_idpaciente", $idpaciente);
$this->assign("paciente_empresa", $paciente_empresa);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
$paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
$vc_final = $paciente["vc_disponibles"] - 1;
$this->assign("vc_disponibles", $vc_final);
$this->assign("vc_disponibles_previa", $paciente["vc_disponibles"]);
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $ManagerEmpresa->getByField("idempresa", $paciente_empresa["empresa_idempresa"]);
$this->assign("empresa", $empresa);

$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente_titular = $ManagerPaciente->get($idpaciente, true);

$this->assign("paciente_titular", $paciente_titular);

//obtenemos el estado de avance del perfil completado
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);


//obtenemos todos los reembolsos
$idusuarioweb = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuarioweb"];
$managerReembolso = $this->getManager("ManagerReembolso");
$reembolsos = $managerReembolso->getReembolsos($idusuarioweb);
$this->assign("reembolsos", $reembolsos);
$estadosRegistrados = $managerReembolso->getCantEstados($idusuarioweb);
$this->assign("estadosRegistrados", $estadosRegistrados);

// obtengo el iban del beneficiario
$managerIban = $this->getManager("ManagerIbanBeneficiario");
$ibanBeneficiario = $managerIban->getByField("usuarioWeb_idusuarioweb", $idusuarioweb);
$this->assign("iban_beneficiario", $ibanBeneficiario);
