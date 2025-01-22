<?php

$idturno = (int) $this->request["idturno"];
//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$ManagerTurno = $this->getManager("ManagerTurno");
$turno = $ManagerTurno->getTurno($idturno);

if ((int) $idturno > 0) {
    if ($turno["paciente_idpaciente"] != "") {
        //verificamos si es del paciente en sesion
        //verificamos si es familiar
        $idpaciente_session = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
        $familiar = $this->getManager("ManagerPacienteGrupoFamiliar")->getPacienteGrupoFamiliar($turno["paciente_idpaciente"], $idpaciente_session);

        if ($turno["paciente_idpaciente"] == $idpaciente_session || $familiar["idpacienteGrupoFamiliar"] != "") {
            $paciente = $this->getManager("ManagerPaciente")->get($turno["paciente_idpaciente"]);
            $this->assign("paciente_turno", $paciente);
            $this->assign("obra_social", $this->getManager("ManagerObrasSociales")->get($turno["obraSocial_idobraSocial"]));
            $this->assign("plan_obra_social", $this->getManager("ManagerPlanesObrasSociales")->get($turno["planObraSocial_idplanObraSocial"]));

            $turno["mensaje_turno"] = $this->getManager("ManagerMensajeTurno")->getListadoMensajes($idturno, $turno["paciente_idpaciente"]);
        } else {
            $this->assign("turno_no_disponible", 1);
        }
    }

    $this->assign("turno", $turno);


    $medico = $this->getManager("ManagerMedico")->get($turno["medico_idmedico"], true);
    $this->assign("medico", $medico);

    $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
    $this->assign("consultorio", $consultorio);

    $this->assign("motivo_visita", $this->getManager("ManagerMotivoVisita")->get($turno["motivovisita_idmotivoVisita"]));

    //buscamos el programa al que pertenece
    if ((int) $turno["idprograma_categoria"] > 0) {
        $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($turno["idprograma_categoria"]);
        $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
        $this->assign("programa_categoria", $programa_categoria);
        $this->assign("programa_salud", $programa_salud);
    }
}
    