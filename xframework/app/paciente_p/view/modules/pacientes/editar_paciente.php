<?php

$managerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");


$all_members = $managerPacienteGrupoFamiliar->getAllPacientesFamiliares($this->request);


$this->assign("completer", $this->request["completer"]);

if (count($all_members) > 0) {
    //Listado de todos los miembros de un grupo...
    $this->assign("filter_selected", "add");
    $this->assign("all_members", $all_members);
}


$header_paciente = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

if (isset($header_paciente["filter_selected"]) && $header_paciente["filter_selected"] != "") {

    if ($header_paciente["filter_selected"] == "self") {
        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"];
    } else {
        $idpaciente = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["header_paciente"]["filter_selected"];
    }


    // <-- LOG
    $log["data"] = "celular, surname, family name, birthday, gender, country of residence, country of work, social security or Passport number + picture, ALD category, CMU-C, Medecin traitant, Mutual company name), User choice : health information accessibility for Professionals";
    $log["page"] = "Personal information";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See Personal information";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--
    // Debo instanciar el paciente
    $ManagerPaciente = $this->getManager("ManagerPaciente");
    $paciente = $ManagerPaciente->get($idpaciente);
    $imagenes_tarjetas = $ManagerPaciente->getImagenesIdentificacion($idpaciente);

    $this->assign("imagenes_tarjetas", $imagenes_tarjetas);

    $this->assign("paciente", $paciente);
    $medico_cabecera = $ManagerPaciente->getMedicoCabecera($idpaciente);
    $this->assign("medico_cabecera", $medico_cabecera);
    //print_r($medico_cabecera);
    //verificamos si es medico de cabecera
    $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
    if ($prof_frecuente) {
        $this->assign("posee_medico_cabecera", "1");
    }

    if ($paciente["email"] == "") {
        $this->assign("combo_relacion_grupo", $this->getManager("ManagerRelacionGrupo")->getCombo());
        $this->assign("filter_selected", $this->request["id"]);
    } else {
        $this->assign("filter_selected", "self");
    }



    //Ver el tema de los combobox
    $managerObraSocialPaciente = $this->getManager("ManagerObraSocialPaciente");
//      $managerObraSocialPaciente->debug();
    $obra_social_paciente = $managerObraSocialPaciente->get($idpaciente);

    //Si es que hay obra social
    if ($obra_social_paciente) {

        $this->assign("obra_social_paciente", $obra_social_paciente);


        //Me fijo de que tipo es la obra social
        $managerObraSocial = $this->getManager("ManagerObrasSociales");
        $obra_social = $managerObraSocial->get($obra_social_paciente["obraSocial_idobraSocial"]);

        $this->assign("obra_social", $obra_social);
    }
    //Afecciones
    $ManagerAfeccionPaciente = $this->getManager("ManagerAfeccionPaciente");

    $afeccion_paciente = $ManagerAfeccionPaciente->getByField("paciente_idpaciente", $idpaciente);

    //Si es que hay obra social
    if ($afeccion_paciente) {





        $afeccion = $this->getManager("ManagerAfeccion")->get($afeccion_paciente["afeccion_idafeccion"]);

        $this->assign("afeccion", $afeccion);
    }
    $this->assign("combo_afeccion", $this->getManager("ManagerAfeccion")->getCombo());
} // END IF FILTER
//print_r($paciente);
//print_r($imagenes_tarjetas);