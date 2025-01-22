<?php

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);

    //ME fijo si es paciente del grupo familiar
    if ($paciente["email"] == "") {
        $ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");
        $pacienteGrupo = $ManagerPacienteGrupoFamiliar->getByField("pacienteGrupo", $paciente["idpaciente"]);
        if ((int) $pacienteGrupo["relacionGrupo_idrelacionGrupo"] > 0) {
            $ManagerRelacionGrupo = $this->getManager("ManagerRelacionGrupo");
            $relacion = $ManagerRelacionGrupo->get($pacienteGrupo["relacionGrupo_idrelacionGrupo"]);
            if ($relacion) {
                $this->assign("relacion_grupo", "Su " . $relacion["relacionInversa"]);
            }
        } else {
            $this->assign("relacion_grupo", "Su parentezco");
        }
    } else {
        $this->assign("relacion_grupo", "Usted");
    }
    $cirugia_ocular_list = $this->getManager("ManagerCirugiaOcular")->getList();

    $this->assign("cirugia_ocular_list", $cirugia_ocular_list);
    //obtenemos el perfil del paciente
    $ManagerPerfilSaludControlVisual=$this->getManager("ManagerPerfilSaludControlVisual");
    $perfilSaludControlVisual=$ManagerPerfilSaludControlVisual->getByField("paciente_idpaciente",$paciente["idpaciente"]);

    $this->assign("perfilSaludControlVisual",$perfilSaludControlVisual);
    //antecedentes de control visual
    $ManagerPerfilSaludControlVisualAntecedentes=$this->getManager("ManagerPerfilSaludControlVisualAntecedentes");
    $list_antecedentes=$ManagerPerfilSaludControlVisualAntecedentes->getListAntecedentes($perfilSaludControlVisual["idperfilSaludControlVisual"]);
    $this->assign("list_antecedentes",$list_antecedentes);
    //patologias actuales
    $list_patologias_actuales=$ManagerPerfilSaludControlVisualAntecedentes->getListPatologiasActuales($perfilSaludControlVisual["idperfilSaludControlVisual"]);
    $this->assign("list_patologias_actuales",$list_patologias_actuales);

    $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register Visual controls";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--