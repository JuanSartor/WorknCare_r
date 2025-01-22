<?php

//Paciente que se encuentra en el array de SESSION de header paciente
$ManagerPaciente = $this->getManager("ManagerPaciente");
$paciente = $ManagerPaciente->getPacienteXHeader();
$this->assign("paciente", $paciente);

$idturno = (int) $this->request["turno"];
$ManagerTurno = $this->getManager("ManagerTurno");

if ((int) $idturno > 0) {

    $turno = $ManagerTurno->getTurno($idturno);


    /**
     * CONTROL DE ACCESO
     * Se va a mostrar si el estado del turno es 4 (se está realizando) o si está en estado cero pero sin ningún paciente
     */
    if ($ManagerTurno->turnoDisponible($paciente["idpaciente"], $idturno)) {
        $this->assign("turno", $turno);


        if ($turno["paciente_idpaciente"] != "") {
            $paciente = $ManagerPaciente->get($turno["paciente_idpaciente"]);

            //Si no es paciente titular, busco el paciente titular
            if ($paciente["email"] == "") {
                $paciente_titular = $ManagerPaciente->getPacienteTitular($turno["paciente_idpaciente"]);
                if ($paciente_titular) {
                    $idpaciente_comparacion = $paciente_titular["idpaciente"];
                }
            } else {
                //Es el paciente titular
                $idpaciente_comparacion = $turno["paciente_idpaciente"];
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
        if ($medico["active"] != 1 || $medico["validado"] != 1) {
            throw new ExceptionErrorPage("No se puede acceder a la información solicitada");
        }

        $this->assign("medico", $medico);

        //verificamos si el paciente puede sacar consultas a medicos de LUX
        if ($paciente["pais_idpais"] == 1 && $paciente["pais_idpais_trabajo"] != 2 && $medico["pais_idpais"] != 1) {
            $this->assign("no_aplica_medico_lux", 1);
        }
        $consultorio = $this->getManager("ManagerConsultorio")->get($turno["consultorio_idconsultorio"]);
        $this->assign("consultorio", $consultorio);

        //calculamos si tiene acceso al perfil de salud el medico
        $this->assign("acceso_perfil_salud", $medico["mis_especialidades"][0]["acceso_perfil_salud"]);

        //modal cambio privacidad
        //si el paciente no tiene el perfil de salud visible para todos y no es frecuente, mostramos el modal de alerta
        $this->assign("txt_change_privacidad", "Professionnels Fréquents et Favoris");
        if ($paciente["privacidad_perfil_salud"] == 0) {
            $this->assign("mostrar_cambio_privacidad", 1);
            $this->assign("perfil_privado", 1);
        } else {
            $this->assign("mostrar_cambio_privacidad", 0);
            $this->assign("perfil_privado", 0);
        }

        //buscamos los motivos por especialidad
        $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByEspecialidad($medico["mis_especialidades"][0]["idespecialidad"]);
        $this->assign("combo_motivo_videoconsulta", $motivos);


        //buscamos el programa al que pertenece
        if ((int) $this->request["idprograma_categoria"] > 0) {
            $programa_categoria = $this->getManager("ManagerProgramaSaludCategoria")->get($this->request["idprograma_categoria"]);
            $programa_salud = $this->getManager("ManagerProgramaSalud")->get($programa_categoria["programa_salud_idprograma_salud"]);
            $this->assign("programa_categoria", $programa_categoria);
            $this->assign("programa_salud", $programa_salud);

            //buscamos los motivos para la especialidad
            $motivos = $this->getManager("ManagerMotivoVideoConsulta")->getComboByProgramaCategoria($this->request["idprograma_categoria"]);
            $this->assign("combo_motivo_videoconsulta", $motivos);
        } else {
            //si no se selecciono el programa mostramos el select para elegirlo
            $ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
            $combo_programas = $ManagerProgramaSaludCategoria->getComboFullCategoriasByMedico($turno["medico_idmedico"]);
            $this->assign("combo_programas", $combo_programas);

            //obtenermos si es paciente empresa y cuantas consultas tiene
            $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
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
        }
    } else {
        //si el turno ya está reservado por el paciente, mostramos la confirmacion
        if ($turno["paciente_idpaciente"] == $paciente["idpaciente"] && ($turno["estado_turno"] == 0 || $turno["estado_turno"] == 1)) {
            header('Location:' . URL_ROOT . "panel-paciente/detalle-turno.html?idturno=" . $idturno);
        }
    }
} else {
    throw new ExceptionErrorPage("No se puede acceder a la información solicitada");
}
