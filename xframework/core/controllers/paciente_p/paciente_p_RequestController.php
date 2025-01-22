<?php

/**
 * @author Xinergia <info@e-xinergia.com>
 * @version 2.0
 *
 * Extensi�n del controlador para procesar las solicitudes del FRONTEND
 * class RequestController: Clase que gestiona y procesa las solicitudes por REQUEST
 *
 * 	
 */
class paciente_p_RequestController extends RequestController {

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Inicializacion del controlador
     *
     *
     * 	@return void
     */
    protected function init() {

        define("THEME", "dp02");
        $this->assign("url_themes", URL_ROOT . "xframework/app/themes/" . THEME . "/");
        $this->assign("url_js_libs", path_libs_js("libs/libs_js/"));

        $this->assign("VIDEOCONSULTA_DURACION", VIDEOCONSULTA_DURACION);
        $this->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $this->assign("VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION", VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION);
        $this->assign("VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO", VIDEOCONSULTA_NOTIFICAR_MEDICO_DEMORADO);
        //precios
        $this->assign("PRECIO_MINIMO_CE", PRECIO_MINIMO_CE);
        $this->assign("PRECIO_MINIMO_VC", PRECIO_MINIMO_VC);
        $this->assign("PRECIO_MINIMO_VC_TURNO", PRECIO_MINIMO_VC_TURNO);
        $this->assign("PRECIO_MAXIMO_CE", PRECIO_MAXIMO_CE);
        $this->assign("PRECIO_MAXIMO_VC", PRECIO_MAXIMO_VC);
        $this->assign("PRECIO_MAXIMO_VC_TURNO", PRECIO_MAXIMO_VC_TURNO);
        //comisiones
        $this->assign("COMISION_VC", COMISION_VC);
        $this->assign("COMISION_CE", COMISION_CE);

        $this->assign("SERVER_EASYRTC_PORT", SERVER_EASYRTC_PORT);
        $this->assign("SERVER_NODE_PORT", SERVER_NODE_PORT);
        $this->assign("GOOGLE_MAPS_KEY", GOOGLE_MAPS_KEY);
        $this->assign("HTTP_HOST", $_SERVER["HTTP_HOST"]);

        $this->assign("path_files", URL_ROOT . "xframework/files/");
        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);

        //Constantes de traduccion
        define("TRADUCCION_IDIOMA", $_SESSION[URL_ROOT]['idioma']);

        $this->assign("translation_file", "translate_" . TRADUCCION_IDIOMA . ".js");
        $this->assign("TRADUCCION_DEFAULT", TRADUCCION_IDIOMA);



        if ($this->request["print"] == "1") {
            $this->setLayout("maestra_print");
        } else {
            $this->setLayout("maestra");
        }

        //autologue si hay una cookie de recordar usuario seteada
        $this->getManager("ManagerUsuarioWeb")->autologin();
        if ((isset($_SESSION[URL_ROOT]["paciente_p"]['allowed']) && $_SESSION[URL_ROOT]["paciente_p"]['allowed'])) {


            $ManagerPaciente = $this->getManager("ManagerPaciente");
            $ManagerPaciente->inicializarPaciente();




            $this->assign("allowed", "1");

            $this->assign("account", $_SESSION[URL_ROOT]["paciente_p"]['logged_account']);
            //verififcamos si es paciente empresa y si está activo
            if ($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente_empresa"] != "") {
                $paciente_empresa = $this->getManager("ManagerPacienteEmpresa")->get($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["paciente"]["idpaciente_empresa"]);

                if ($paciente_empresa["estado"] != "1") {
                    unset($_SESSION[URL_ROOT][CONTROLLER]);
                    unset($_SESSION[URL_ROOT]["paciente_p"]);
                    if ($this->isAction()) {
                        $resultado = array("result" => false, "msg" => "Accès refusé: La session est terminée. Vous devez vous reconnecter");
                        $this->finish($resultado);
                        exit();
                    }
                    //Si viene de ajax y no es accion
                    if (isset($this->request['fromajax']) && (int) $this->request['fromajax'] == 1) {
                        die("access denied");
                        exit();
                    } else {

                        header("Location: " . URL_ROOT);
                        exit();
                    }
                }
            }
            if (isset($_SESSION[URL_ROOT]["paciente_p"]['logged_account'])) {
                $modulo = $this->request["modulo"];
                $submodulo = $this->request["submodulo"];

                if ($modulo == "videoconsulta" && ($submodulo == "videoconsulta" || $submodulo == "videoconsulta_mobile")) {
                    $this->setLayout("maestra_videoconsulta");
                    require_once(path_libs_php("Mobile-Detect/Mobile_Detect.php"));

                    $detect = new Mobile_Detect;
                    // Any mobile device (phones or tablets).
                    if ($detect->isMobile()) {
                        $submodulo = "videoconsulta_mobile";
                        $this->request["submodulo"] = "videoconsulta_mobile";
                    } else {

                        $submodulo = "videoconsulta";
                        $this->request["submodulo"] = "videoconsulta";
                        // $submodulo = "videoconsulta_mobile";
                        //$this->request["submodulo"] = "videoconsulta_mobile";
                    }
                }
                if ($modulo == "videoconsulta" && ($submodulo == "videoconsulta_1" || $submodulo == "videoconsulta_mobile_1")) {
                    $this->setLayout("maestra_videoconsulta");
                    require_once(path_libs_php("Mobile-Detect/Mobile_Detect.php"));

                    $detect = new Mobile_Detect;
                    // Any mobile device (phones or tablets).
                    if ($detect->isMobile()) {
                        $submodulo = "videoconsulta_mobile_1";
                        $this->request["submodulo"] = "videoconsulta_mobile_1";
                    } else {

                        $submodulo = "videoconsulta_1";
                        $this->request["submodulo"] = "videoconsulta_1";
                        // $submodulo = "videoconsulta_mobile";
                        //$this->request["submodulo"] = "videoconsulta_mobile";
                    }
                }
                $action = 0;
                if ($this->isAction()) {
                    $action = 1;
                } else {

                    $info_menu = $ManagerPaciente->getInfoMenu();
                    $this->assign("info_menu", $info_menu);
                    $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
                    $cantidad_notificaciones = $ManagerConsultaExpress->getCantidadConsultasExpressPacienteXEstado();
                    $this->assign("cantidad_notificaciones", $cantidad_notificaciones);
                    $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
                    $videoconsulta_notificaciones = $ManagerVideoConsulta->getCantidadVideoConsultasPacienteXEstado();
                    $this->assign("videoconsulta_notificaciones", $videoconsulta_notificaciones);
                }

                /**
                 * PACIENTE
                 */
                if (isset($_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["tipousuario"]) && $_SESSION[URL_ROOT]["paciente_p"]['logged_account']["user"]["tipousuario"] == "paciente") {
                    
                }
            }


            $this->assign("account", $_SESSION[URL_ROOT]["paciente_p"]['logged_account']);
        } else {

            //Si es acción              
            if ($this->isAction()) {
                $resultado = array("result" => false, "msg" => "Accès refusé: La session est terminée. Vous devez vous reconnecter");
                $this->finish($resultado);
                exit();
            }
            //Si viene de ajax y no es accion
            if (isset($this->request['fromajax']) && (int) $this->request['fromajax'] == 1) {
                die("access denied");
                exit();
            } else {
                $_SESSION[URL_ROOT]["frontend_2"]["redirect"] = $_SERVER[REQUEST_URI];
                $_SESSION[URL_ROOT]["frontend_2"]["redirect_controller"] = "paciente_p";

                header("Location: " . URL_ROOT);
                exit();
            }
        }



        $this->setSeo(true);
    }

    /**
     * get seo
     *
     * */
    public function getSeo() {


        $seo = array(
            "meta_title" => "WorknCare | Patient",
            "meta_keywords" => "téléconsultation,télémédecine,téléexpertise,vidéo consultation, médecin,rendez-vous, doctorplus, Pass bien-être, pass bien-etre, ordonnance, spécialiste, patient, WorknCare, workncare",
            "meta_description" => "WorknCare | Patient",
            "image" => URL_ROOT . "xframework/app/themes/dp02/imgs/passbienetre-logo-og.jpg"
        );

        return $seo;
    }

}

// end_class
?>