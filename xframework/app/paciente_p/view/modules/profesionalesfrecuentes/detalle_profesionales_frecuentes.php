<?php

if (isset($this->request["idmedico"]) && $this->request["idmedico"] != "") {
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
    }
    $this->assign("paciente", $paciente);
    $idpaciente = $paciente["idpaciente"];

    $ManagerMedico = $this->getManager("ManagerMedico");
    $medico = $ManagerMedico->get($this->request["idmedico"], true);
    $medico["imagen"] = $ManagerMedico->getImagenMedico($this->request["idmedico"]);
    $medico["valoracion"] = $this->getManager("ManagerProfesionalValoracion")->getCantidadRecomendaciones($medico["idmedico"]);
    $medico["estrellas"] = $this->getManager("ManagerProfesionalValoracion")->getCantidadEstrellas($medico["idmedico"]);
    $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($medico["preferencia_idPreferencia"]);
    $medico["preferencia"] = $preferencia;
    $medico["consultorios"] = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($medico["idmedico"]);
    $medico["paciente_sincargo"] = $this->getManager("ManagerMedicoMisPacientes")->is_paciente_sin_cargo($idpaciente, $medico["idmedico"]);
    $medico["idiomas"] = $this->getManager("ManagerIdiomaMedico")->getIdiomasMedico($medico["idmedico"]);
    $medico["favorito"] = $this->getManager("ManagerProfesionalFavorito")->isFavorito($medico["idmedico"], $idpaciente);
    $medico["frecuente"] = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($medico["idmedico"], $idpaciente);
    $medico["obras_sociales"] = $this->getManager("ManagerObraSocialMedico")->getObrasSocialesMedico($medico["idmedico"]);
    $medico["vacaciones"] = $this->getManager("ManagerMedicoVacaciones")->getVacacionesMedico($medico["idmedico"]);
    $listado_web_profesional = $this->getManager("ManagerMedicoWebProfesional")->listado_web_profesional($medico["idmedico"]);
    $this->assign("listado_web_profesional", $listado_web_profesional);

//inicialiamos los ids de consultorio para los mapas
    if ($medico["consultorios"] && count($medico["consultorios"]) > 0) {

        foreach ($medico["consultorios"] as $key => $value) {
            if ($value["idconsultorio"] != "" && $value["is_virtual"] == "0") {
                $id_cons = $value["idconsultorio"];
                $id_consultorios .= "$id_cons,";
            } else {
                //verificamos si el medico solo ofrece videoconsultas a sus pacientes y es frecuente
                //Seteamos en el nombre de consultorio como disponible solo para sus pacientes
                if ($medico["preferencia"]["pacientesVideoConsulta"] == "2") {
                    $frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->isFrecuente($medico["idmedico"], $paciente["idpaciente"]);

                    if (!$frecuente) {
                        $medico["consultorios"][$key]["videoconsulta_no_disponible"] = 1;
                    }
                }
            }
        }

        if (strlen($id_consultorios) > 0) {
            $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
        }
        $this->assign("id_consultorios", $id_consultorios);
    }

    //si el profesional ofrece los servicios solo a sus paciente, verificamos si el paciente pertenece al listado de pacientes del medico
    if ($preferencia["pacientesConsultaExpress"] == 2 || $preferencia["pacientesVideoConsulta"] == 2) {
        $is_paciente = $this->getManager("ManagerMedicoMisPacientes")->getRelacion($medico["idmedico"], $idpaciente);
        if (!$is_paciente) {

            if ($preferencia["pacientesConsultaExpress"] == 2) {
                $medico["consultaexpress_solo_pacientes"] = 1;
            }
            if ($preferencia["pacientesVideoConsulta"] == 2) {
                $medico["videoconsulta_solo_pacientes"] = 1;
            }
        }
    }

    if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"] != "") {
        $this->assign("prestador", $this->getManager("ManagerPrestador")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["prestador_idprestador"]));
        $this->assign("login_prestador", 1);
    }

//verificamos si es medico de cabecera
    $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_idmedico"], [$paciente["idpaciente"], $medico["idmedico"]]);
    if ($prof_frecuente["medico_cabecera"] == 1) {
        $medico["medico_cabecera"] = 1;
    } else {
        $medico["medico_cabecera"] = 0;
    }
    $this->assign("medico", $medico);

    //verificamos si el medico está incluido en los planes cubiertos por la empresa
    if ($paciente_empresa) {
        $medico_bonificado = $this->getManager("ManagerProgramaSaludExcepcion")->verificar_medico_bonificado($medico["idmedico"], $paciente_empresa["empresa_idempresa"]);
        if ($medico_bonificado) {
            $this->assign("medico_bonificado", 1);
        }
    }
}
