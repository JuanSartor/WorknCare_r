<?php

//Id es el correspondiente al turno
  if (isset($this->request["id"]) && $this->request["id"] != "") {
      $ManagerTurno = $this->getManager("ManagerTurno");
     
      //$ManagerTurno->debug();
      $detalle_turno = $ManagerTurno->getDetalleTurno($this->request["id"]);
    
     
      if ($detalle_turno != FALSE) {
          $detalle_turno["nroturno"] = str_pad($detalle_turno["idturno"], 10, "0", STR_PAD_LEFT);
          if ($detalle_turno["email"] == "") {
              $ManagerPaciente = $this->getManager("ManagerPaciente");
              $detalle_turno["email"] = $ManagerPaciente->getPacienteEmail($detalle_turno["idpaciente"]);
          }

          $this->assign("detalle_turno", $detalle_turno);
       
      }


      list($a, $m, $d) = preg_split("[-]", $detalle_turno["fecha"]);

      $nombre_dia = getDiaSemana($d, $m, $a);
      $nombre_mes = getNombreMes(date("n", mktime(0, 0, 0, $m, $d, $a)));

      $this->assign("nombre_dia", $nombre_dia);

      $this->assign("nombre_mes", $nombre_mes);
      
    // <-- LOG
    $log["data"] = "Consultation detail";
    $log["page"] = "Agenda";
    $log["action"] = "val"; //"val" "vis" "del"
    $log["purpose"] = "See appointment Physical Consultation/Video Consultation";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);
    // 
  }
  

  