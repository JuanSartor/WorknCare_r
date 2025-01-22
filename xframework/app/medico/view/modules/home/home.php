<?php

$ManagerMedico = $this->getManager("ManagerMedico");
$medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
$this->assign("medico", $medico);
$preferencia = $this->getManager("ManagerPreferencia")->get($medico["preferencia_idPreferencia"]);
$consultorio_vitrual = $this->getManager("ManagerConsultorio")->getConsultorioVirtual($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);



$mis_especialidades = $this->getManager("ManagerEspecialidadMedico")->getEspecialidadesMedico($medico["idmedico"]);

//verificamos las informacion completa
$info_consultorios_completo = 1;
if ($medico["direccion_iddireccion"] == "" || $consultorio_vitrual["idconsultorio"] == "" || $preferencia["valorPinesConsultaExpress"] == "" || $preferencia["valorPinesVideoConsulta"] == "" || $preferencia["valorPinesVideoConsultaTurno"] == "") {
    $info_consultorios_completo = 0;
}
if ($medico["pais_idpais"] == 1) {

    //verificamos si tiene numero ADELI requerido
    if ($mis_especialidades[0]["tipo_identificacion"] == 1 && $medico["numero_adeli"] == "") {
        $info_consultorios_completo = 0;
    }

    //verificamos si tiene numero RPPS requerido
    if ($mis_especialidades[0]["tipo_identificacion"] == 0 && $medico["numero_rpps"] == "") {
        $info_consultorios_completo = 0;
    }

    //verificamos si tiene numero AM requerido
    if ($mis_especialidades[0]["requiere_numero_am"] == 1 && $medico["numero_am"] == "") {
        $info_consultorios_completo = 0;
    }

    //verificamos si tiene sector requerido
    if ($mis_especialidades[0]["requiere_sector"] == 1 && $medico["sector_idsector"] == "") {
        $info_consultorios_completo = 0;
    }

    //verificamos si tiene modo de facturacion requerido
    if ($mis_especialidades[0]["requiere_modo_facturacion"] == 1 && $medico["facturacion_teleconsulta"] == "") {
        $info_consultorios_completo = 0;
    }
}
$this->assign("consultorios_completo", $info_consultorios_completo);

$medico_vacaciones = $this->getManager("ManagerMedicoVacaciones")->getVacacionesMedico($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
$this->assign("medico_vacaciones", $medico_vacaciones);



