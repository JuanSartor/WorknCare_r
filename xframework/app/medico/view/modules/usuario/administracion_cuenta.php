<?php

    //obtenemos el medico

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];


    $ManagerMedico = $this->getManager("ManagerMedico");
    $medico = $ManagerMedico->get($idmedico, true);
   
    $this->assign("medico", $medico);

    //obtenemos la preferencia del medico
    $ManagerPreferencia = $this->getManager("ManagerPreferencia");

    $this->assign("preferencia", $ManagerPreferencia->getPreferenciaMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));

    //obtenemos la suscripcion premium
    $suscripcion=$this->getManager("ManagerSuscripcionPremium")->getSuscripcionActiva($idmedico);
    $this->assign("suscripcion",$suscripcion);

    // <-- LOG
    $log["data"] = "type of subscription (free account, monthly subscription)";
    $log["page"] = "Account settings";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "Type of account";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--