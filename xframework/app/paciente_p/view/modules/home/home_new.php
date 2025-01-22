<?php

/**
 *
 *  Home >>  Home
 *
 */
$ManagerPacienteGrupoFamiliar = $this->getManager("ManagerPacienteGrupoFamiliar");

$ManagerPaciente = $this->getManager("ManagerPaciente");

$filtros = $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["header_paciente"];

if (isset($filtros["filter_selected"]) && $filtros["filter_selected"] == "all") {
    $ManagerPaciente->change_member_session(["requerimiento" => "self"]);
}
if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["miembro_seleccionado"] == 1) {
    $this->assign("miembro_seleccionado", 1);
}

$paciente_logueado = $ManagerPaciente->get_basic($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente"]);
$this->assign("paciente_logueado", $paciente_logueado);

//obtenemos el estado de avance del perfil completado

$paciente = $ManagerPaciente->getPacienteXHeader();
$paciente_notificacion = $ManagerPaciente->get_basic($paciente["idpaciente"]);
$this->assign("paciente_notificacion", $paciente_notificacion);

if ($paciente) {


    // print_r($paciente);
    $this->assign("paciente", $paciente);

    //medicos frecuentes
    $medicos_frecuentes_list = $ManagerPaciente->getMedicosFrecuentesList($this->request, NULL, NULL, NULL);

    $this->assign("medicos_frecuentes_list", $medicos_frecuentes_list);

    $medicos_sugeridos_list = $ManagerPaciente->getMedicosSugeridosList($paciente["idpaciente"]);

    $this->assign("medicos_sugeridos_list", $medicos_sugeridos_list);


    //controles y chequeos
    $ManagerNotificacion = $this->getManager("ManagerNotificacion");
    $listado_controles_chequeos = $ManagerNotificacion->getListadoControlesChequeosHome($paciente["idpaciente"]);

    $this->assign("listado_controles_chequeos", $listado_controles_chequeos);

    $this->includeSubmodule('home', 'home_new_turnos');
    //wizard perfil ya finalizado
    $perfil_salud = $this->getManager("ManagerPerfilSaludStatus")->getByField("paciente_idpaciente", $paciente["idpaciente"]);
    $this->assign("wizard_step", $perfil_salud["wizard_step"]);

    //verificamos si es medico de cabecera
    $prof_frecuente = $this->getManager("ManagerProfesionalesFrecuentesPacientes")->getByFieldArray(["paciente_idpaciente", "medico_cabecera"], [$paciente["idpaciente"], 1]);
    $paciente_basic = $ManagerPaciente->get_basic($paciente["idpaciente"]);
    if ($prof_frecuente || $paciente_basic["medico_cabeza_externo"] == 1) {
        $this->assign("posee_medico_cabecera", "1");
    }

    /*     * verificamos si quedo una consulta en borrador* */
    $ConsultaExpress = $this->getManager("ManagerConsultaExpress")->getConsultaExpressBorrador($paciente["idpaciente"]);
    $this->assign("ConsultaExpress", $ConsultaExpress);

    //verificamos si quedo una consulta en borrador
    $VideoConsulta = $this->getManager("ManagerVideoConsulta")->getVideoConsultaBorrador($paciente["idpaciente"]);
    $this->assign("VideoConsulta", $VideoConsulta);

    //verificamos si quedo una turno en borrador
    $turno_borrador = $this->getManager("ManagerTurno")->getByFieldArray(["paciente_idpaciente", "estado"], [$paciente["idpaciente"], "4"]);
    if ($turno_borrador) {
        $turno_borrador["is_turno_videoconsulta"] = $this->getManager("ManagerTurno")->is_turno_videoconsulta($turno_borrador["idturno"]) ? "1" : "0";
    }
    $this->assign("turno_borrador", $turno_borrador);
}

//print_r($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]);
$ManagerPerfilSaludStatus = $this->getManager("ManagerPerfilSaludStatus");
$statusPerfil = $ManagerPerfilSaludStatus->getByField("paciente_idpaciente", $paciente["idpaciente"]);

$this->assign("statusPerfil", $statusPerfil);
$url_perfil_salud = $ManagerPerfilSaludStatus->getUrlSeccionIncompleta($statusPerfil);
if ($url_perfil_salud) {
    $this->assign("url_perfil_salud", $url_perfil_salud);
}


$managerTurno = $this->getManager("ManagerTurno");


//OBtengo la cantidad de turnos válidos del paciente
$this->assign("cantidad_turnos", $managerTurno->getCantidadTurnosValidosPaciente($paciente["idpaciente"]));
$this->assign("combo_afeccion", $this->getManager("ManagerAfeccion")->getCombo());

//Especialidades del profesional
$managerEspecialidades = $this->getManager("ManagerEspecialidades");
$combo_especialidades = $managerEspecialidades->getCombo();
$this->assign("combo_especialidades", $combo_especialidades);


// obtengo el estado de la contraseña del usuario web para ver si ejecuto el modal de cambio de contraseña
// por iniciar sesion por primera vez
$managerUsuarioWeb = $this->getManager("ManagerUsuarioWeb");
$usuarioweb = $managerUsuarioWeb->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["usuarioweb_idusuarioweb"]);
$this->assign("estado_password", $usuarioweb["cambiar_pass"]);

// <-- LOG
/* $log["data"] = "User choice : health information accessibility for Professionals";
  $log["page"] = "Home page (connected)";
  $log["action"] = "vis"; //"val" "vis" "del"
  $log["purpose"] = "See User preferences";

  $ManagerLog = $this->getManager("ManagerLog");
  $ManagerLog->track($log); */

// <--
// obtengo el listado de banner
$ManagerBannerPromocion = $this->getManager("ManagerBannerPromocion");
$listado_banners = $ManagerBannerPromocion->getListadoBannersActivos();
$this->assign("listado_banner_activos", $listado_banners);


//obtenermos si es paciente empresa y los programas bonificados
$paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->getByField("paciente_idpaciente", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
$empresa = $this->getManager("ManagerEmpresa")->get($paciente_empresa["empresa_idempresa"]);
$this->assign("empresaCompleta", $empresa);

// si es un beneficiario, es decir no es un particular entra y sino pasa a el else deonde seteo none
if ($paciente_empresa) {

    $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($paciente_empresa["plan_idplan"]);
    $this->assign("plan_contratado", $plan_contratado);
    $paciente["ce_disponibles"] = (int) $plan_contratado["cant_consultaexpress"] - (int) $paciente_empresa["cant_consultaexpress"];
    $paciente["vc_disponibles"] = (int) $plan_contratado["cant_videoconsulta"] - (int) $paciente_empresa["cant_videoconsulta"];
    $this->assign("vc_disponibles", $paciente["vc_disponibles"]);
    if ((int) $paciente["ce_disponibles"] > 0 || (int) $paciente["vc_disponibles"] > 0) {
        $ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
        $excepciones_programa = $ManagerProgramaSaludExcepcion->getByField("empresa_idempresa", $paciente_empresa["empresa_idempresa"]);
        if ($excepciones_programa["programa_salud_excepcion"] != "") {
            $this->assign("ids_excepciones_programa", $excepciones_programa["programa_salud_excepcion"]);
        } else {
            $this->assign("ids_excepciones_programa", "ALL");
        }
    } else {
        // este else lo agrego Juan el 27-04-2022 porque pasa que si se quedan sin vc y ce
        // no debe mostrar offert
        $this->assign("ids_excepciones_programa", "NONE");
    }
} else {
    $this->assign("ids_excepciones_programa", "NONE");
}

$prestacionesDisponibles = $paciente["ce_disponibles"] + $paciente["vc_disponibles"];
$this->assign("prestaciones_disponibles", $prestacionesDisponibles);
// obtengo todos los programas del pass
$listado_grupo_programas = $this->getManager("ManagerProgramaSaludGrupo")->getListadoGrupoProgramas();

$lista_parte_inicial = Array();
$lista_parte_final = Array();
$array_excepciones = explode(",", $excepciones_programa["programa_salud_excepcion"]);

foreach ($listado_grupo_programas as &$grupo) {
    foreach ($grupo["listado_programas"] as &$elemento) {

        if (in_array($elemento["idprograma_salud"], $array_excepciones)) {
            array_push($lista_parte_final, $elemento);
        } else {
            array_push($lista_parte_inicial, $elemento);
        }
    }
}

$arreglo_final = array_merge($lista_parte_inicial, $lista_parte_final);
$this->assign("listado_grupo_programas", $arreglo_final);


// asigno para ver que empresa es, si es Particulier no es un beneficiario
$this->assign("empresa_beneficiario", $empresa["empresa"]);



// con lo siguiente armo el array de programas para los programas de socios
$lista_programas_socios = Array();
if ($arreglo_final == "") {
    $lista_programas_socios = "";
} else {
    foreach ($arreglo_final as &$programa) {
        if (!in_array($programa["idprograma_salud"], $array_excepciones)) {
            array_push($lista_programas_socios, $programa);
        }
    }
}
$this->assign("listado_grupo_programas_socios", $lista_programas_socios);


$ManagerGanador = $this->getManager("ManagerGanadoresRecompensa");
$cant_recompensas_ganadas = $ManagerGanador->getCantRecompensasGanadas($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["usuarioweb_idusuarioweb"]);
$this->assign("cant_recompensas_ganadas", $cant_recompensas_ganadas["cantidad"]);

$recompensas_ganadas = $ManagerGanador->obtenerRecompensasGanadas($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["usuarioweb_idusuarioweb"]);
$this->assign("recompensas_ganadas", $recompensas_ganadas);
