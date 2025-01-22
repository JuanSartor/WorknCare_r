<?php

    //Id es el correspondiente al turno
    if (isset($this->request["idturno"]) && $this->request["idturno"] != "") {
        $ManagerTurno = $this->getManager("ManagerTurno");

        //$ManagerTurno->debug();
        $turno = $ManagerTurno->get($this->request["idturno"]);
        $turno["is_virtual"] = $ManagerTurno->is_turno_videoconsulta($this->request["idturno"]);
        
        if ($turno != FALSE) {
            $turno["nroturno"] = str_pad($turno["idturno"], 10, "0", STR_PAD_LEFT);

            if (strtotime($turno["fecha"] . " " . $turno["horarioInicio"]) < strtotime(date("Y-m-d H:i:s"))) {
                $turno["turno_pasado"] = 1;
            }
            $this->assign("turno", $turno);
        }
    //ortenemos y asignamos la fecha del turno
        list($a, $m, $d) = preg_split("[-]", $turno["fecha"]);
        $this->assign("dia", $d);
        $this->assign("anio", $a);

        $dia = getNumeroDiaSemana($d, $m, $a);
        $nombre_dia = getNombreCortoDia($dia);
        $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $m, $d, $a)));

        $this->assign("nombre_dia", $nombre_dia);
        $this->assign("nombre_mes", $nombre_mes);

        //motivos visita del turno
        if($turno["is_virtual"]==1){
             $this->assign("combo_motivo_videoconsulta", $this->getManager("ManagerMotivoVideoConsulta")->getCombo());
        }else{
             $this->assign("combo_motivo_visita", $this->getManager("ManagerMotivoVisita")->getCombo());
        }
       
        //combo de relacion grupo paciente familiar
        $this->assign("combo_relacion_grupo", $this->getManager("ManagerRelacionGrupo")->getCombo());
    }
    
    // <-- LOG
    $log["data"] = "List of patients";
    $log["page"] = "Agenda";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "Search patient to book medical appointment";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--
