<?php

    if (isset($this->request["idmedico"]) && $this->request["idmedico"] != "") {
        //Paciente que se encuentra en el array de SESSION de header paciente


        $ManagerMedico = $this->getManager("ManagerMedico");
        $medico = $ManagerMedico->get($this->request["idmedico"], true);
        $medico["imagen"] = $ManagerMedico->getImagenMedico($this->request["idmedico"]);
        $medico["valoracion"] = $this->getManager("ManagerProfesionalValoracion")->getCantidadRecomendaciones($medico["idmedico"]);
        $medico["estrellas"] = $this->getManager("ManagerProfesionalValoracion")->getCantidadEstrellas($medico["idmedico"]);
        $medico["preferencia"] = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);
        $medico["consultorios"] = $this->getManager("ManagerConsultorio")->getListconsultorioMedico($medico["idmedico"]);
        $medico["idiomas"] = $this->getManager("ManagerIdiomaMedico")->getIdiomasMedico($medico["idmedico"]);
        $medico["obras_sociales"] = $this->getManager("ManagerObraSocialMedico")->getObrasSocialesMedico($medico["idmedico"]);
        $medico["posee_videoconsulta"] = $ManagerMedico->poseeVideoConsulta($medico["idmedico"]);
        $medico["posee_consultapresencial"] = $ManagerMedico->poseeConsultaPresencial($medico["idmedico"]);

        //inicialiamos los ids de consultorio para los mapas
        if ($medico["consultorios"] && count($medico["consultorios"]) > 0) {

            foreach ($medico["consultorios"] as $key => $value) {
                if ($value["idconsultorio"] != "" && $value["is_virtual"] == "0") {
                    $id_cons = $value["idconsultorio"];
                    $id_consultorios .= "$id_cons,";
                }
            }

            if (strlen($id_consultorios) > 0) {
                $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
            }
            $this->assign("id_consultorios", $id_consultorios);
        }

        $this->assign("medico_detalle", $medico);
       
    }

    // <-- LOG
    $log["data"] = "data professional information";
    $log["page"] = "Professional information";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Professional info";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--