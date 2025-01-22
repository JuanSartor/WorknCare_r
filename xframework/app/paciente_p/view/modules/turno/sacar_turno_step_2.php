<?php

$idturno = (int) $this->request["turno"];
$ManagerTurno = $this->getManager("ManagerTurno");

if ((int) $idturno > 0) {
    $turno = $ManagerTurno->getTurno($idturno);
    $this->assign("turno", $turno);

    if ($turno["paciente_idpaciente"] != "") {
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);
        if ($paciente["email"] == "") {
            $paciente["email"] = $ManagerPaciente->getPacienteEmail($paciente["idpaciente"]);
        }
    }
    $this->assign("paciente", $paciente);


    $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"], true);
    //verificamos si es medico de cabecera
    $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $turno["medico_idmedico"]]);
    if ($prof_frecuente["medico_cabecera"] == 1) {
        $medico["medico_cabecera"] = 1;
    } else {
        $medico["medico_cabecera"] = 0;
    }
    $this->assign("medico", $medico);

    $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
    $this->assign("consultorio", $consultorio);

    $this->assign("motivo_visita", $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"]));

    if ($turno["obraSocial_idobraSocial"] != "") {
        $this->assign("obra_social", $this->getManager("ManagerObrasSociales")->get($turno["obraSocial_idobraSocial"]));
    }
    if ($turno["planObraSocial_idplanObraSocial"] != "") {
        $this->assign("plan_obra_social", $this->getManager("ManagerPlanesObrasSociales")->get($turno["planObraSocial_idplanObraSocial"]));
    }
}
