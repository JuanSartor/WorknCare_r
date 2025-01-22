<?php

    $idpaginate = "paginacion_medico";
    $this->assign("idpaginate", $idpaginate);

    if (is_array($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"])) {
        unset($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"]);
    }
    
    $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"] = $this->request;

    $tags_inputs = $this->getManager("ManagerMedico")->getTagsInputBusquedaProfesional($this->request);

    $this->assign("tags_inputs", $tags_inputs);
    //  $ManagerMedico->print_r($tags_inputs);die();

    if ((int) $this->request["especialidad_ti"] > 0) {
        $this->assign("especialidad", $this->getManager("ManagerEspecialidades")->get($this->request["especialidad_ti"]));
    }

    // <-- LOG
    $log["data"] = "Professional information";
    $log["page"] = "Search result";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See list of Profesionnals";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--