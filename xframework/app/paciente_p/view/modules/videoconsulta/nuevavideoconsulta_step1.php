<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();

//obtenermos si es paciente empresa y cuantas consultas tiene
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
if ($paciente_empresa) {
    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];

    //obtenermos si es paciente empresa y los programas bonificados
    if ((int) $paciente["vc_disponibles"] > 0) {
        $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
        $excepciones_programa = $ManagerProgramaSaludExcepcion->getByField("empresa_idempresa", $paciente_empresa["empresa_idempresa"]);
        if ($excepciones_programa["programa_salud_excepcion"] != "") {
            $this->assign("ids_excepciones_programa", $excepciones_programa["programa_salud_excepcion"]);
        } else {
            $this->assign("ids_excepciones_programa", "ALL");
        }
    }
}
$this->assign("paciente", $paciente);



$this->assign("combo_sector", $this->getManager("ManagerSector")->getCombo(1));

//Especialidades del profesional
$managerEspecialidades = $this->getManager("ManagerEspecialidades");
$combo_especialidades = $managerEspecialidades->getCombo(1);
$this->assign("combo_especialidades", $combo_especialidades);


$this->includeSubmodule('videoconsulta', 'rango_precios_profesionales_red');

$ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
$combo_programas = $ManagerProgramaSaludCategoria->getComboFullCategorias();
$this->assign("combo_programas", $combo_programas);




