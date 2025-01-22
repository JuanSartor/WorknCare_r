<?php

$ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
$ManagerPaciente = $this->getManager("ManagerPaciente");
//Hago la inserción inicial 
if (!isset($this->request["idperfilSaludConsulta"]) || $this->request["idperfilSaludConsulta"] == "") {

    //verificamos si proviene de una consulta express asociada
    if (isset($this->request["idconsultaExpress"]) && $this->request["idconsultaExpress"] != "") {

        $ConsultaExpress = $this->getManager("ManagerConsultaExpress")->get($this->request["idconsultaExpress"]);

        //verificamos que la consulta este en estado pendiente de finalizacion
        if ($ConsultaExpress["estadoConsultaExpress_idestadoConsultaExpress"] == "8") {
            //verificamos si ya hay una consulta creada para esa consulta express  y la recuperamos
            $consulta = $ManagerPerfilSaludConsulta->getByField("consultaExpress_idconsultaExpress", $this->request["idconsultaExpress"]);
            if ($consulta["idperfilSaludConsulta"] != "") {
                $idconsulta = $consulta["idperfilSaludConsulta"];
            } else {
                //en caso contrario creamos una consulta para esta CE
                $record["paciente_idpaciente"] = $this->request["idpaciente"];

                $record["consultaExpress_idconsultaExpress"] = $this->request["idconsultaExpress"];
                $idconsulta = $ManagerPerfilSaludConsulta->insert($record);
            }
        } else {
            $this->assign("consultaexpress_finalizada", 1);
        }
        $ConsultaExpress["motivoConsultaExpress"] = $this->getManager("ManagerMotivoConsultaExpress")->get($ConsultaExpress["motivoConsultaExpress_idmotivoConsultaExpress"]);

        $this->assign("ConsultaExpress", $ConsultaExpress);
    }
    ///verificamos si proviene de un turno de videoconsulta asociada
    if (isset($this->request["idturno"]) && $this->request["idturno"] != "") {
        $videoconsulta = $this->getManager("ManagerVideoConsulta")->getByField("turno_idturno", $this->request["idturno"]);
        $this->request["idvideoconsulta"] = $videoconsulta["idvideoconsulta"];
    }
    ////verificamos si proviene de una videoconsulta asociada
    if (isset($this->request["idvideoconsulta"]) && $this->request["idvideoconsulta"] != "") {

        $videoconsulta = $this->getManager("ManagerVideoConsulta")->get($this->request["idvideoconsulta"]);

        //verificamos que la videoconsulta este pendiente de finalizacion
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == "8") {
            //verificamos si ya hay una consulta creada para esa videoconsulta y la recuperamos
            $consulta = $ManagerPerfilSaludConsulta->getByField("videoconsulta_idvideoconsulta", $this->request["idvideoconsulta"]);
            if ($consulta["idperfilSaludConsulta"] != "") {
                $idconsulta = $consulta["idperfilSaludConsulta"];
            } else {
                //en caso contrario creamos una consulta para esta VC
                $record["paciente_idpaciente"] = $this->request["idpaciente"];
                $record["videoconsulta_idvideoconsulta"] = $this->request["idvideoconsulta"];
                $idconsulta = $ManagerPerfilSaludConsulta->insert($record);
            }
        } else {

            $this->assign("videoconsulta_finalizada", 1);
        }

        $videoconsulta["motivoVideoConsulta"] = $this->getManager("ManagerMotivoVideoConsulta")->get($videoconsulta["motivoVideoConsulta_idmotivoVideoConsulta"]);

        $this->assign("videoconsulta", $videoconsulta);
    }
    //si no se trata de una consulta expres, o videconsulta, insertamos la consulta medica sin asociarla a estas
    if ($this->request["idvideoconsulta"] == "" && $this->request["idconsultaExpress"] == "" && $idconsulta == "") {
        $record["paciente_idpaciente"] = $this->request["idpaciente"];
        $idconsulta = $ManagerPerfilSaludConsulta->insert($record);
    }
} else {

    $idconsulta = (int) $this->request["idperfilSaludConsulta"];
}


if (isset($this->request["idturno"]) && (int) $this->request["idturno"] > 0) {
    $ManagerTurno = $this->getManager("ManagerTurno");
    $turno = $ManagerTurno->get($this->request["idturno"]);
    $this->assign("turno", $turno);
}

//Si se inserto 
if ($idconsulta > 0) {

    //Id del paciente que el médico elije

    $idpaciente = $this->request["idpaciente"];


    $ManagerMedico = $this->getManager("ManagerMedico");

    $paciente_permitido = $ManagerMedico->getPacienteMedico($idpaciente);

    if ($paciente_permitido) {
        $paciente = $ManagerPaciente->get($idpaciente);
        $this->assign("paciente", $paciente);
    }

    $record = $ManagerPerfilSaludConsulta->get($idconsulta);
    $this->assign("record", $record);

    $ManagerPerfilSaludMedicamento = $this->getManager("ManagerPerfilSaludMedicamento");
    $listado_medico = $ManagerPerfilSaludMedicamento->getListMedicacionMedicoConsulta(array("paciente_idpaciente" => $idpaciente, "idperfilSaludConsulta" => $idconsulta));
    if ($listado_medico) {
        $this->assign("list_medicacion_medico", $listado_medico);
    }


    $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
    $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
    $this->assign("idpaginate", $paginate . "_" . $idpaciente);
    $listado = $ManagerPerfilSaludEstudios->getListEstudiosConsulta(array(
        "idpaciente" => $idpaciente,
        "do_reset" => $_SESSION['SmartyPaginate'][$paginate . "_" . $idpaciente]["current_item"] == "1" ? 1 : "",
        "idperfilSaludConsulta" => $idconsulta), $paginate . "_" . $idpaciente
    );
    if ($listado) {
        $this->assign("listado_imagenes", $listado);
        $this->assign("cantidad_imagenes", count($listado));
    }

    //cargamos el perfil se salud
    if ($this->request["mis_registros_consultas_medicas"] != 1) {
        $this->assign("item_menu", "consults");
        $estadoTablero = $this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
        $this->assign("estadoTablero", $estadoTablero);

        $info_menu = $ManagerPaciente->getInfoMenu($paciente["idpaciente"]);
        $this->assign("info_menu_paciente", $info_menu);

        //Obtengo los tags INputs
        $tags = $ManagerPerfilSaludConsulta->getInfoTags($idpaciente);
        if ($tags) {
            $this->assign("tags", $tags);
        }
    }


    $this->assign("idmedico", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);

    $ManagerTipoTomaMedicamentos = $this->getManager("ManagerTipoTomaMedicamentos");
    $this->assign("combo_tipo_toma_medicamento", $ManagerTipoTomaMedicamentos->getCombo());
}
$medico = $this->getManager("ManagerMedico")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"], 1);

//die($medico["mis_especialidades"][0]["idespecialidad"]);
$this->assign("medico", $medico);
$this->assign("idespecialidad", $medico["mis_especialidades"][0]["idespecialidad"]);

// <-- LOG
$log["data"] = "Data conclusion";
$log["page"] = "Consultation Express";
$log["action"] = "vis"; //"val" "vis" "del"
$log["purpose"] = "See Consultation Express CONCLUSION";

$ManagerLog = $this->getManager("ManagerLog");
$ManagerLog->track($log);

// <--