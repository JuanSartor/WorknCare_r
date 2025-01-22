<?php

    //Obtener el listado de períodos del médico
    $ManagerPeriodoPago = $this->getManager("ManagerPeriodoPago");
    $this->assign("combo_periodo_pago", $ManagerPeriodoPago->getCombo());
     $utlimo_periodo_pago = $ManagerPeriodoPago->getLast();
     
     $this->assign("idPeriodoActual", $utlimo_periodo_pago["idperiodoPago"]);

    if (isset($this->request["idperiodoPago"]) && $this->request["idperiodoPago"] != "") {
        $this->assign("idperiodoPago", $this->request["idperiodoPago"]);
        $periodo_pago=$ManagerPeriodoPago->get($this->request["idperiodoPago"]);
        
        $this->assign("periodo_pago", $periodo_pago);
    } else {
       
        $this->assign("idperiodoPago", $utlimo_periodo_pago["idperiodoPago"]);
        $this->assign("periodo_pago", $utlimo_periodo_pago);
    }

    // <-- LOG
    $log["data"] = "Amounts received for all types of consultations";
    $log["page"] = "My account";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Panel";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--