<?php

//obtenemos la Video Consulta
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$idvideoconsulta = $ManagerVideoConsulta->getProximaVideoConsulta();

if($idvideoconsulta){
  
    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];

    $medico = $this->getManager("ManagerMedico")->get($idmedico, true);
    $this->assign("medico", $medico);

    $videoconsulta = $ManagerVideoConsulta->get($idvideoconsulta);
    
    $mensajes_videoconsulta=$this->getManager("ManagerMensajeVideoConsulta")->getListadoMensajesChatVC($idvideoconsulta);
      $mensajes_videoconsulta=  json_encode($mensajes_videoconsulta);
    $this->assign("mensajes_videoconsulta",$mensajes_videoconsulta);

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




        //si la consulta ya estaba iniciada seteamos cuanto tiempo le queda
        if ($videoconsulta["estadoVideoConsulta_idestadoVideoConsulta"] == 7 && $videoconsulta["inicio_llamada"] != "") {


            //$ManagerVideoConsulta->cambiarEstado(["idvideoconsulta" => $idvideoconsulta, "estadoVideoConsulta_idestadoVideoConsulta" => 8]);
        } else {
        //si la consulta no estaba iniciada seteamos el tiempo de espera del paciente

            $segundos_espera = VIDEOCONSULTA_VENCIMIENTO_SALA;

            $this->assign("segundos_espera", $segundos_espera);
        }

        if ($videoconsulta["paciente_idpaciente"] != "") {

           $this->assign("videoconsulta_sala", $videoconsulta);

            //creamos el nombre de la sala
            $room = "{$videoconsulta["idvideoconsulta"]}-{$videoconsulta["medico_idmedico"]}-{$videoconsulta["paciente_idpaciente"]}";
            $room = base64_encode($room);
            $room = str_replace("=", "", $room);
            $this->assign("room_name", $room);

            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $paciente = $ManagerPaciente->get($videoconsulta["paciente_idpaciente"]);

            //obtenemos el titular de la cuenta si es un familiar
            $realciongrupo = $this->getManager("ManagerPacienteGrupoFamiliar")->getByField("pacienteGrupo", $paciente["idpaciente"]);

            if ($realciongrupo["pacienteTitular"] != "") {
                //Traigo la informacion del paciente titular
                $paciente["paciente_titular"] = $ManagerPaciente->get($realciongrupo["pacienteTitular"]);
                $paciente["paciente_titular"]["relacion"] = $this->getManager("ManagerRelacionGrupo")->get($realciongrupo["relacionGrupo_idrelacionGrupo"])["relacionGrupo"];
            }
            $this->assign("paciente", $paciente);

            //print_r($paciente);
            //Obtengo los tags INputs
            $ManagerPerfilSaludConsulta = $this->getManager("ManagerPerfilSaludConsulta");
            $tags = $ManagerPerfilSaludConsulta->getInfoTags($paciente["idpaciente"]);
          
            if ($tags) {
                $this->assign("tags", $tags);
             
            
            }

            //obtengo los prof frecuentes
            $ManagerProfesionalesFrecuentesPacientes = $this->getManager("ManagerProfesionalesFrecuentesPacientes");
            $listado = $ManagerProfesionalesFrecuentesPacientes->getListadoProfesionalesFrecuentesPaciente($videoconsulta["paciente_idpaciente"], $idmedico);

            if ($listado && count($listado) > 0) {
                $this->assign("listado_profesionales_frecuentes", $listado);
            }
        }
    }
}