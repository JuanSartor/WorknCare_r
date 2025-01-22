<?php

$idturno = (int) $this->request["turno"];
$ManagerTurno = $this->getManager("ManagerTurno");

if ((int) $idturno > 0) {
    $turno = $ManagerTurno->getTurno($idturno);
    $this->assign("turno", $turno);

    if ($turno["paciente_idpaciente"] != "") {
        $ManagerPaciente = $this->getManager("ManagerPaciente");
        $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);

        $paciente["email"] = $ManagerPaciente->getPacienteEmail($turno["paciente_idpaciente"]);
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

    $this->assign("motivo_videoconsulta", $this->getManager("ManagerMotivoVideoConsulta")->get($turno["motivoVideoConsulta_idmotivoVideoConsulta"]));

    //paciente logueado con prestador
    if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
        $this->assign("login_prestador", 1);
        $prestador = $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]);
        $this->assign("prestador", $prestador);
    }
}
