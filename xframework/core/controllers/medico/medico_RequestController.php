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
class medico_RequestController extends RequestController {

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

        $this->assign("MONTO_CUOTA", MONTO_CUOTA);

        $this->assign("url_themes", URL_ROOT . "xframework/app/themes/" . THEME . "/");
        $this->assign("url_js_libs", url_core("libs/libs_js/"));

        $this->assign("VIDEOCONSULTA_DURACION", VIDEOCONSULTA_DURACION);
        $this->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $this->assign("VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION", VIDEOCONSULTA_HORAS_PENDIENTE_FINALIZACION);
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

        //Constantes de traduccion
        define("TRADUCCION_IDIOMA", $_SESSION[URL_ROOT]['idioma']);
        $this->assign("translation_file", "translate_" . TRADUCCION_IDIOMA . ".js");
        $this->assign("TRADUCCION_DEFAULT", TRADUCCION_IDIOMA);

        $this->assign("path_files", URL_ROOT . "xframework/files/");


        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);
        if ($this->request["print"] == "1") {
            $this->setLayout("maestra_print");
        } else {
            $this->setLayout("maestra");
        }

        //autologue si hay una cookie de recordar usuario seteada
        $this->getManager("ManagerUsuarioWeb")->autologin();
        if ((isset($_SESSION[URL_ROOT][CONTROLLER]['allowed']) && $_SESSION[URL_ROOT][CONTROLLER]['allowed'])) {

            $this->assign("allowed", "1");
            $this->assign("account", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']);


            if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account'])) {
                $modulo = $this->request["modulo"];
                $submodulo = $this->request["submodulo"];

                //setemaos la maestra de videoconsulta si es necesario
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

                //setemaos la maestra de videoconsulta si es necesario
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
                }




                /**
                 * MEDICO
                 */
                if (isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"]) && $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["tipousuario"] == "medico") {
                    
                }
            }

            $smarty = SmartySingleton::getInstance();

            $ManagerMedico = $this->getManager("ManagerMedico");


            $medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
            $smarty->assign("medico", $medico);

            $info_menu = $ManagerMedico->getInfoMenu($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
            $smarty->assign("info_menu", $info_menu);

            $imagen = $ManagerMedico->getImagenMedico();
            $smarty->assign("imagen_medico", $imagen);
            //cantidad consultas express icono notificacion
            $ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
            $cantidad_notificaciones = $ManagerConsultaExpress->getCantidadConsultasExpressMedicoXEstado();
            $smarty->assign("cantidad_notificaciones", $cantidad_notificaciones);
            //cantidad videoconsultas icono notificacion
            $ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
            $videoconsulta_notificaciones = $ManagerVideoConsulta->getCantidadVideoConsultasMedicoXEstado();
            $smarty->assign("videoconsulta_notificaciones", $videoconsulta_notificaciones);
            //cantidad de turnos pendientes para icono de notificacion
            $ManagerTurno = $this->getManager("ManagerTurno");
            $turnos_pendientes_notificaciones = $ManagerTurno->getCantidadTurnosPendientes();
            $smarty->assign("turnos_pendientes_notificaciones", $turnos_pendientes_notificaciones);
            //obtengo el proximo turno pendiente
            $proximo_turno_pendiente = $ManagerTurno->getProximoTurnoPendiente();
            $smarty->assign("proximo_turno_pendiente", $proximo_turno_pendiente);


            $this->assign("account", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']);
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

                //variable para la redireccion si no esta logueado
                $_SESSION[URL_ROOT]["frontend_2"]["redirect"] = $_SERVER[REQUEST_URI];
                $_SESSION[URL_ROOT]["frontend_2"]["redirect_controller"] = "medico";

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
            "meta_title" => "WorknCare | Médecin",
            "meta_keywords" => "téléconsultation,télémédecine,téléexpertise,vidéo consultation, médecin,rendez-vous, doctorplus, ordonnance, spécialiste, patient",
            "meta_description" => "WorknCare | Médecin",
            "image" => URL_ROOT . "xframework/app/themes/dp02/imgs/passbienetre-logo-og.jpg"
        );

        return $seo;
    }

}

// end_class
?>
