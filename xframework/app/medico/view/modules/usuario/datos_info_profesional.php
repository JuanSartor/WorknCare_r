<?php

    $idmedico = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"];

    $ManagerMedico = $this->getManager("ManagerMedico");
    $medico = $ManagerMedico->get($idmedico, true);
    $imgs = $ManagerMedico->getImagenMedico($idmedico);
    $this->assign("medico", $medico);
    
    $this->assign("imgs", $imgs);

    /* 
    $name_image = "perfil_crop_" . $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"] . ".jpg";
    $DestinationDirectory = path_entity_files("medicos/$idmedico/");

    if (is_file($DestinationDirectory.$name_image)) {
    $image = URL_ROOT . "xframework/files/entities/medicos/$idmedico/";
    $image .= $name_image;
    $this->assign("image_perfil_profesional", $image);
    } 
    */

    $this->assign("combo_especialidades", $this->getManager("ManagerEspecialidades")->getCombo());

    //Combo tipo Profesional
    $ManagerTituloProfesional = $this->getManager("ManagerTituloProfesional");
    $titulo_profesional= $ManagerTituloProfesional->getCombo();
    
    $this->assign("combo_tipo_profesional",$titulo_profesional);
    
      //Combo Sector
    $ManagerSector = $this->getManager("ManagerSector");
    $this->assign("combo_sector", $ManagerSector->getCombo());
    $managerProvincia = $this->getManager("ManagerProvincia");
    $provincias = $managerProvincia->getComboProvinciasArgentinas();
    $this->assign("combo_provincias", $provincias);


    //getSubEspecialidadesTagsInputMedico
    $ManagerEspecialidadMedico = $this->getManager("ManagerEspecialidadMedico");
    
    $ManagerEspecialidades = $this->getManager("ManagerEspecialidades");

    $this->assign("mis_especialidades", $ManagerEspecialidades->getEspecialidadesTagsInputMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));

    $ManagerSubEspecialidades = $this->getManager("ManagerSubEspecialidades");
    $this->assign("mis_subespecialidades", $ManagerSubEspecialidades->getSubEspecialidadesTagsInputMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));

    //getEspecialidadesMedico
    $data = $ManagerEspecialidadMedico->getEspecialidadesMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
    
    
    $this->assign("medico_especialidad", $data);

    if (count($data) > 0) {
        $idespecialidad = $data[0]["idespecialidad"];
        $this->assign("combo_sub_especialidades", $ManagerSubEspecialidades->getCombo($idespecialidad));
    }

    if ($medico["imageDNI_idimageDNI"] != "") {
        $ManagerImageDNI = $this->getManager("ManagerImageDNI");
        $image_dni = $ManagerImageDNI->getImgs($medico["imageDNI_idimageDNI"]);
        if ($image_dni) {
            $this->assign("image_dni", $image_dni);
        }
    }
     $this->assign("listado_web_profesional", $this->getManager("ManagerMedicoWebProfesional")->listado_web_profesional($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));

    //Idiomas
    $this->assign("combo_idiomas", $this->getManager("ManagerIdiomas")->getCombo());

    $this->assign("mis_idiomas", $this->getManager("ManagerIdiomaMedico")->getIdiomasMedico($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]));
    $imagenes_tarjetas = $ManagerMedico->getImagenesIdentificacion($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
    $this->assign("imagenes_tarjetas", $imagenes_tarjetas);

    // <-- LOG
    $log["data"] = "data professional information";
    $log["page"] = "Professional information";
    $log["action"] = "vis"; //"val" "vis" "del"
    $log["purpose"] = "See all professional info";

    $ManagerLog = $this->getManager("ManagerLog");
    $ManagerLog->track($log);

    // <--