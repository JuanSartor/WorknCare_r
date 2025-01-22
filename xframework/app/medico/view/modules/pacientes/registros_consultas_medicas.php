<?php
    
    $this->assign("item_menu", "consults");

    $idpaciente=$this->request["idpaciente"];
    if ((int) $idpaciente > 0) {
        $ManagerMedico = $this->getManager("ManagerMedico");
        $paciente = $ManagerMedico->getPacienteMedico($idpaciente);
        if ($paciente) {
            $this->assign("paciente", $paciente);
        }      
    }
  
    // <-- LOG
    $log["data"] = "consultation data";
    $log["page"] = "Medical records";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See all consultations performed with patient";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--