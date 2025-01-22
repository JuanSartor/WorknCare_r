<?php

    $ManagerInformacionComercialMedico = $this->getManager("ManagerInformacionComercialMedico");
    $idmedico=$_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];
    $info = $ManagerInformacionComercialMedico->getInformacionComercialMedico($idmedico);

    $this->assign("info_comercial", $info);

    $ManagerMedico = $this->getManager("ManagerMedico");
    $medico = $ManagerMedico->get($idmedico, true);

    $this->assign("medico", $medico);

    // <-- LOG
    $log["data"] = "IBAN, Bank";
    $log["page"] = "Professional information";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See bank account details";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--