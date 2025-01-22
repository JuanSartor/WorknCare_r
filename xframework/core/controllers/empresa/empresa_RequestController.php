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
class empresa_RequestController extends RequestController {

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


// obtengo el plan contratado para mostrarlo en el header
        $plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
        $this->assign("plan_contratado", $plan_contratado);

        if ($this->request["print"] == "1") {
            $this->setLayout("maestra_print");
        } else {
            $this->setLayout("maestra");
        }
        //print_r($_SESSION[URL_ROOT]["empresa"]['logged_account']);
        if ((isset($_SESSION[URL_ROOT]["empresa"]['allowed']) && $_SESSION[URL_ROOT]["empresa"]['allowed'])) {

            $this->assign("allowed", "1");

            $this->assign("account", $_SESSION[URL_ROOT]["empresa"]['logged_account']);

            if (isset($_SESSION[URL_ROOT]["empresa"]['logged_account'])) {
                $modulo = $this->request["modulo"];
                $submodulo = $this->request["submodulo"];


                $action = 0;
                if ($this->isAction()) {
                    $action = 1;
                } else {
                    
                }
            }


            $this->assign("account", $_SESSION[URL_ROOT]["empresa"]['logged_account']);
            $manager = $this->getManager("ManagerEmpresa");
            $record = $manager->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
            $this->assign("record", $record);
            $ac = $_SESSION[URL_ROOT]["empresa"]['logged_account'];
            $userempre = $this->getManager("ManagerUsuarioEmpresa")->get($ac["id"]);
            $this->assign("userempre", $userempre);
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
                $_SESSION[URL_ROOT]["frontend_2"]["redirect_controller"] = "empresa";

                header("Location: " . URL_ROOT . "creer-compte.html?free=1");
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
            "meta_title" => "WorknCare | Pass estanté administration",
            "meta_keywords" => "téléconsultation,télémédecine,téléexpertise,vidéo consultation, médecin,rendez-vous, doctorplus, WorknCare, pass bien-etre ordonnance, spécialiste, patient",
            "meta_description" => "WorknCare | Pass estanté administration",
            "image" => URL_ROOT . "xframework/app/themes/dp02/imgs/passbienetre-logo-og.jpg"
        );

        return $seo;
    }

}

// end_class
?>