<?php

//obtenemos el estado de avance del perfil completado

$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$listado_programas = $this->getManager("ManagerProgramaSalud")->getListadoProgramas();
$this->assign("listado_programas", $listado_programas);

//obtenermos si es paciente empresa y los programas bonificados
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);

    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
    if ((int) $paciente["ce_disponibles"] > 0 || (int) $paciente["vc_disponibles"] > 0) {
        $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
        $excepciones_programa = $ManagerProgramaSaludExcepcion->getByField("empresa_idempresa", $paciente_empresa["empresa_idempresa"]);
        if ($excepciones_programa["programa_salud_excepcion"] != "") {
            $this->assign("ids_excepciones_programa", $excepciones_programa["programa_salud_excepcion"]);
        } else {
            $this->assign("ids_excepciones_programa", "ALL");
        }
    }
}


