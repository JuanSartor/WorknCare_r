<?php

$fecha = $this->request["fecha"];
if ($fecha == "") {
    $fecha = date('m/d/Y');
} else {
    $fecha = date('m/d/Y', strtotime($fecha));
}

//Si requiere el siguiente día
if (isset($this->request["week"]) && $this->request["week"] == "next") {
    $fecha = date('m/d/Y', strtotime('+7 day', strtotime($fecha)));
}
//Si requiere el día anterior
elseif (isset($this->request["week"]) && $this->request["week"] == "previous") {
    $fecha = date('m/d/Y', strtotime('-7 day', strtotime($fecha)));
}
//Si hay diferencia de semanas es porque pide el próximo turno que está disponible
elseif (isset($this->request["diferencia_semanas"]) && $this->request["diferencia_semanas"] != "") {
    $cantidad_dias = (int) $this->request["diferencia_semanas"] * 7;
    $fecha = date('m/d/Y', strtotime("+$cantidad_dias day", strtotime(date('m/d/Y'))));
}


$this->assign("dia_agenda", $fecha);





if ($this->request["idmedico"] != "" && $this->request["idconsultorio"] != "") {
    $ManagerMedico = $this->getManager("ManagerMedico");
    $managerConsultorio = $this->getManager("ManagerConsultorio");
    $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($this->request["idmedico"]);
    $consultorio = $managerConsultorio->get($this->request["idconsultorio"]);

    //verificamos si el medico solo ofrece videoconsultas a sus pacientes y es frecuente 

    if ($consultorio["is_virtual"] == "1" && $preferencia["pacientesVideoConsulta"] == "2") {
        $paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
        $is_paciente = $this->getManager("ManagerMedicoMisPacientes")->getRelacion($medico["idmedico"], $idpaciente);
        if (!$is_paciente) {
            $this->assign("videoconsulta_no_disponible", 1);
        }
    }

    $agenda_semanal = $ManagerMedico->getAgendaSemanal($this->request["idmedico"], $this->request["idconsultorio"], $fecha);

    $this->assign("agenda", $agenda_semanal);
    $this->assign("consultorio", $consultorio);
    $this->assign("medico", $ManagerMedico->get($this->request["idmedico"]));
    $this->assign("idconsultorio_contenedor", $this->request["idconsultorio_contenedor"]);
    $this->assign("preferencia", $preferencia);

    $cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
    //obtenermos si es paciente empresa y cuantas consultas tiene
    $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
    if ($paciente_empresa) {
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
        $this->assign("paciente_empresa", $paciente_empresa);
        $this->assign("plan_contratado", $plan_contratado);
        $cuenta_paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
        $cuenta_paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
    }
    $this->assign("cuenta_paciente", $cuenta_paciente);
}