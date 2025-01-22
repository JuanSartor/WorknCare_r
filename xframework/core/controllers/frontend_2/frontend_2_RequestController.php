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
class frontend_2_RequestController extends RequestController {

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

        $this->assign("path_files", URL_ROOT . "xframework/files/");
        $this->assign("MONTO_CUOTA", MONTO_CUOTA);
        //comisiones
        $this->assign("COMISION_VC", COMISION_VC);
        $this->assign("COMISION_CE", COMISION_CE);

        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);


        if ($_SESSION[URL_ROOT]['idioma'] == "") {
            $_SESSION[URL_ROOT]['idioma'] = TRADUCCION_DEFAULT;
        }

        //Constantes de traduccion

        define("TRADUCCION_IDIOMA", $_SESSION[URL_ROOT]['idioma']);

        $this->assign("translation_file", "translate_" . TRADUCCION_IDIOMA . ".js");
        $this->assign("TRADUCCION_IDIOMA", TRADUCCION_IDIOMA);
        $this->assign("GOOGLE_MAPS_KEY", GOOGLE_MAPS_KEY);
        $this->assign("RECAPTCHA_PUBLIC", RECAPTCHA_PUBLIC);

        //autologue si hay una cookie de recordar usuario seteada
        $this->getManager("ManagerUsuarioWeb")->autologin();

        //Me fijo si hay un paciente o un médico Logueado
        if ((isset($_SESSION[URL_ROOT]["medico"]['allowed']) && $_SESSION[URL_ROOT]["medico"]['allowed']) || (isset($_SESSION[URL_ROOT]["paciente_p"]['allowed']) && $_SESSION[URL_ROOT]["paciente_p"]['allowed'])) {

            //Son los submodulos que van a estar permitidos para el médico para que pueda acceder al fontend_2
            $submodulos_permitidos = array(
                "proceso_pago", "registracion_abono", "404"
            );

            //Obtengo el nombre del controller de la persona que está logueada
            if (isset($_SESSION[URL_ROOT]["medico"])) {
                $controller = "medico";
            } elseif (isset($_SESSION[URL_ROOT]["paciente_p"])) {
                $controller = "paciente_p";
            }

            $this->assign("allowed", "1");
            $this->assign("account", $_SESSION[URL_ROOT][$controller]['logged_account']);


            //Me fijo si hay una cuenta logueada
            if (isset($_SESSION[URL_ROOT][$controller]['logged_account'])) {
                $modulo = $this->request["modulo"];
                $submodulo = $this->request["submodulo"];

                $action = 0;
                if ($this->isAction()) {
                    $action = 1;
                }


                /**
                 * Si el usuario logueado es médico
                 */
                if ($controller == "medico" && !in_array($submodulo, $submodulos_permitidos) && !$action) {

                    $modulo = ($modulo == "") ? "home" : $modulo;

                    $submodulo = ($submodulo == "") ? "home" : $submodulo;
                    $this->request["modulo"] = $modulo;
                    $this->request["submodulo"] = $submodulo;
                    header("Location:" . URL_ROOT . "panel-medico/");
                }

                /**
                 * Si el usuario logueado es médico
                 */ elseif ($controller == "paciente_p" && !in_array($submodulo, $submodulos_permitidos) && !$action) {

                    $modulo = ($modulo == "") ? "home" : $modulo;
                    $submodulo = ($submodulo == "") ? "home_new" : $submodulo;
                    $this->request["modulo"] = $modulo;
                    $this->request["submodulo"] = $submodulo;
                    header("Location:" . URL_ROOT . "panel-paciente/");
                } else {
                    $this->setLayout("maestra");
                }
            }
        } else {

            //En caso de que no esté logueado
            $modulo = $this->request["modulo"];
            $submodulo = $this->request["submodulo"];
            $this->default_module = "home_w";
            $this->default_submodule = "index";
            $this->setLayout("maestra");



            $action = 0;
            if ($this->isAction()) {
                $action = 1;
            }
        }



        $this->setSeo(true);
    }

    /**
     * get seo
     *
     * */
    public function getSeo() {
        if ($this->request["submodulo"] == "bienvenida_cuestionario") {
            $seo["meta_title"] = "Questionnaire";
            $description = "Merci de répondre à ces questions !";
        } elseif ($this->request["submodulo"] == "bienvenida_capsula") {
            $seo["meta_title"] = "Capsule d’information";
            $description = "Merci de regarder la capsule !";
        } elseif ($this->request["submodulo"] == "bienvenida_container") {
            $seo["meta_title"] = "Pass";
            $description = "Merci de vous connecter!";
        } else {
            $seo["meta_title"] = "WorknCare";
            $description = "La solution simple et automatisée : DUERP, Capsules d'information, évaluations, Pass ciblés.";
        }

        $seo = array(
            "meta_title" => "WorknCare",
            "meta_keywords" => "WorknCare , workncare,téléconsultation,télémédecine,téléexpertise,vidéo consultation, médecin,rendez-vous, doctorplus, WorknCare, pass bien-être, pass bien-etre, ordonnance, spécialiste, patient,experts en santé,programmes de santé, WorknCare, workncare",
            "meta_description" => $description,
            "image" => URL_ROOT . "xframework/app/themes/dp02/imgs/logo-workncare-link.jpg"
        );
        if ($this->request["modulo"] == "programa_salud_registro") {
            if ($this->request["submodulo"] == "bienvenida_cuestionario") {
                $seo["meta_title"] = "Questionnaire";
                $seo["image"] = URL_ROOT . "xframework/app/themes/dp02/imgs/logo-questionnaire.png";
            } elseif ($this->request["submodulo"] == "bienvenida_capsula") {
                $seo["meta_title"] = "Capsule d’information";
                $seo["image"] = URL_ROOT . "xframework/app/themes/dp02/imgs/logo-capsule.png";
            } elseif ($this->request["submodulo"] == "bienvenida_container") {
                $seo["meta_title"] = "Pass";
                $seo["image"] = URL_ROOT . "xframework/app/themes/dp02/imgs/logo-pass.png";
            } else {
                $seo["meta_title"] = "WorknCare";
                $seo["image"] = URL_ROOT . "xframework/app/themes/dp02/imgs/logo-workncare-link.jpg";
            }
        }

        return $seo;
    }

}

// end_class
?>
