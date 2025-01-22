<?php

    $this->assign("item_menu", "consults");

    //Id del paciente que el médico elije
    if (isset($_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]) && $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"] != "") {
        $idpaciente = $_SESSION[URL_ROOT]["medico"]['logged_account']["paciente_session"]["idpaciente"];
    } else {
        $idpaciente = $this->request["idpaciente"];
    }

    if ($idpaciente != "") {
        $idpaciente = $idpaciente;
    }
    if ((int) $idpaciente > 0) {
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
        if ($paciente) {
            $this->assign("paciente", $paciente);
        }

        //Obtengo los tags INputs
        $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
        $tags = $ManagerPerfilSaludConsulta->getInfoTags($idpaciente);
        if ($tags) {
            $this->assign("tags", $tags);
        }
    }


    $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");

    $this->assign("idpaginate", "mis_registros_pacientes_" . $idpaciente);
    $this->assign("idpaciente", $idpaciente);

    //  $ManagerPerfilSaludConsulta->debug();

    $listado = $ManagerPerfilSaludConsulta->getListadoPaginado($this->request, "mis_registros_pacientes_" . $idpaciente);

    if ($listado) {
        $this->assign("listado", $listado);
    }

    if ($this->request["mis_registros_consultas_medicas"] == 1) {
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
        if ($paciente) {
            $this->assign("paciente", $paciente);
        }
    }

    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
    $this->assign("info_menu_paciente", $info_menu);

    $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);

    // <-- LOG
    $log["data"] = "Health Profile Info";
    $log["page"] = "Patient Health profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Patient Health Profile";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--