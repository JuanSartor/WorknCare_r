<?php

//obtenemos la Video Consulta
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$idvideoconsulta = $ManagerVideoConsulta->getProximaVideoConsulta();
if ($idvideoconsulta != "") {

    $videoconsulta = $ManagerVideoConsulta->get($idvideoconsulta);
    $mensajes_videoconsulta = $this->getManager("ManagerMensajeVideoConsulta")->getListadoMensajesChatVC($idvideoconsulta);
    $mensajes_videoconsulta = json_encode($mensajes_videoconsulta);

    $this->assign("mensajes_videoconsulta", $mensajes_videoconsulta);

    //verificamos si esta habilitada la sala ya
    if (strtotime($videoconsulta["inicio_sala"]) > strtotime(date("Y-m-d H:i:s"))) {

        //list($fecha, $hora)=split(" ",$videoconsulta["inicio_sala"]);
        //verificamos si la fecha de la proxima es hoy
        //segundos para la proxima
        $segundos_restantes = strtotime($videoconsulta["inicio_sala"]) - strtotime(date("Y-m-d H:i:s"));

        if ((int) $segundos_restantes < (60 * 60)) {//si es en menos de 1 hs
            $min_restantes = (int) $segundos_restantes / 60;
            $min_restantes = substr($min_restantes, 0, strpos($min_restantes, "."));

            $tiempo_proxima = "en $min_restantes minuto/s";
            $this->assign("tiempo_proxima", $tiempo_proxima);
        } else {
            //la proxima videoconsulta es en mas de 1hs
            $tiempo_proxima = "el " . fechaToString($videoconsulta["inicio_sala"], 1) . "hs.";
            $this->assign("tiempo_proxima", $tiempo_proxima);
        }
    } else {

        $ManagerPaciente = $this->getManager("ManagerPaciente");
        //obtenemos la informacion del paciente de la Video Consulta    
        $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);
        $realciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente["idpaciente"]);
        if ($realciongrupo["pacienteTitular"] != "") {
            //Traigo la informacion del paciente titular
            $paciente["paciente_titular"] = $ManagerPaciente->get($realciongrupo["pacienteTitular"]);
            $paciente["paciente_titular"]["relacion"] = $this->getManager("ManagerRelacionGrupo")->get($realciongrupo["relacionGrupo_idrelacionGrupo"])["relacionGrupo"];
        }
        $this->assign("paciente", $paciente);

        if ($videoconsulta["medico_idmedico"] != "") {

            //creamos el nombre de la sala
            $room = "{$videoconsulta["idvideoconsulta"]}-{$videoconsulta["medico_idmedico"]}-{$videoconsulta["paciente_idpaciente"]}";
            $room = base64_encode($room);
            $room = str_replace("=", "", $room);
            $this->assign("room_name", $room);

            $ManagerMedico = $this->getManager("ManagerMedico");
            $medico = $ManagerMedico->get($videoconsulta["medico_idmedico"], true);
            $medico["imagen"] = $ManagerMedico->getImagenMedico($videoconsulta["medico_idmedico"]);

            $this->assign("medico", $medico);

            //print_r($medico);

            $this->assign("videoconsulta_sala", $videoconsulta);

            $ManagerVideoConsultaSession = $this->getManager("ManagerVideoConsultaSession");
            $videoconsulta_session = $ManagerVideoConsultaSession->getByField("videoconsulta_idvideoconsulta", $idvideoconsulta);
            $videoconsulta_session["apiKey"]=TOKBOX_API_KEY;
            $this->assign("videoconsulta_session", $videoconsulta_session);
        }
    }
}