<?php

$fecha = $this->request["fecha"];
if ($fecha == "") {
    $fecha = date('m/d/Y');
} else {
    $fecha = date('m/d/Y', strtotime($fecha));
}

//Si requiere el siguiente día
if (isset($this->request["week"]) && $this->request["week"] == "next") {
    $fecha = date('m/d/Y', strtotime('+7 day', strtotime($fecha)));
}
//Si requiere el día anterior
elseif (isset($this->request["week"]) && $this->request["week"] == "previous") {
    $fecha = date('m/d/Y', strtotime('-7 day', strtotime($fecha)));
}
//Si hay diferencia de semanas es porque pide el próximo turno que está disponible
elseif (isset($this->request["diferencia_semanas"]) && $this->request["diferencia_semanas"] != "") {
    $cantidad_dias = (int) $this->request["diferencia_semanas"] * 7;
    $fecha = date('m/d/Y', strtotime("+$cantidad_dias day", strtotime(date('m/d/Y'))));
}


$this->assign("dia_agenda", $fecha);





if ($this->request["idmedico"] != "" && $this->request["idconsultorio"] != "") {
    $ManagerMedico = $this->getManager("ManagerMedico");
    $managerConsultorio = $this->getManager("ManagerConsultorio");

    $consultorio = $managerConsultorio->get($this->request["idconsultorio"]);
    $this->assign("consultorio", $consultorio);
    $this->assign("medico", $ManagerMedico->get($this->request["idmedico"]));
    $this->assign("idconsultorio_contenedor", $this->request["idconsultorio_contenedor"]);

    if ($consultorio["is_virtual"] == 1) {

        //Busco la cuenta del usuario y lo que cobra el médico la video consulta
        $cuenta_paciente = $this->getManager("ManagerCuentaUsuario")->getCuentaPaciente($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
        $preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($this->request["idmedico"]);
  
       
        
        $this->assign("cuenta_paciente", $cuenta_paciente);
        $this->assign("preferencia", $preferencia);
    }
    $agenda_semanal = $ManagerMedico->getAgendaSemanal($this->request["idmedico"], $this->request["idconsultorio"], $fecha);

    $this->assign("agenda", $agenda_semanal);
}