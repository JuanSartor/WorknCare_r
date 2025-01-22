<?php

$idturno = (int) $this->request["turno"];
$ManagerTurno = $this->getManager("ManagerTurno");

if ((int) $idturno > 0) {
    $turno = $ManagerTurno->getTurno($idturno);
    $this->assign("turno", $turno);

    if ($turno["paciente_idpaciente"] != "") {
        $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
    }
    $this->assign("paciente", $paciente);

    $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"], true);
    $this->assign("medico", $medico);

    $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
    $this->assign("consultorio", $consultorio);

    $this->assign("motivo_visita", $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"]));

    $this->assign("obra_social", $this->getManager("ManagerObrasSociales")->get($turno["obraSocial_idobraSocial"]));

    $this->assign("plan_obra_social", $this->getManager("ManagerPlanesObrasSociales")->get($turno["planObraSocial_idplanObraSocial"]));

    //buscamos el programa al que pertenece
    if ((int) $turno["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($turno["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);
    }
}
