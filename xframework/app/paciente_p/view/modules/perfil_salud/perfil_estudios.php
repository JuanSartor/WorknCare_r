<?php

    $this->assign("item_menu", "images");

    //Paciente que se encuentra en el array de SESSION de header paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");

    $paciente = $ManagerPaciente->getPacienteXHeader();
    $this->assign("paciente", $paciente);
    //$ManagerPaciente->print_r($paciente);

    $ManagerPerfilSaludEstudios = $this->getManager("ManagerPerfilSaludEstudios");
    $paginate = $ManagerPerfilSaludEstudios->getDefaultPaginate();
    $this->assign("idpaginate", $paginate . "_" . $paciente["idpaciente"]);

    $this->request["idpaciente"] = $paciente["idpaciente"];
    $this->request["do_reset"] = 1;
    $listado = $ManagerPerfilSaludEstudios->getListImages($this->request, $paginate . "_" . $paciente["idpaciente"]);
    //$ManagerPaciente->print_r($listado);die();
    if (count($listado["rows"]) > 0) {
        $this->assign("listado_imagenes", $listado);
        $this->assign("cantidad_imagenes", $ManagerPerfilSaludEstudios->getCantEstudiosPaciente($this->request));
    }

    $estadoTablero=$this->getManager("ManagerPerfilSaludStatus")->getStatusPerfilPaciente($paciente["idpaciente"]);
    $this->assign("estadoTablero", $estadoTablero);
 
    $ConsultaExpressPermitida = $ManagerPaciente->isPermitidoConsultaExpress($paciente["idpaciente"]);
    $this->assign("ConsultaExpressPermitida", $ConsultaExpressPermitida);
    $VideoConsultaPermitida = $ManagerPaciente->isPermitidoVideoConsulta($paciente["idpaciente"]);
    $this->assign("VideoConsultaPermitida", $VideoConsultaPermitida);

    // <-- LOG
    $log["data"] = "Register List of pictures & files";
    $log["page"] = "Health Profile";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See information Health Profile";    

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--