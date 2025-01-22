<?php

/**
 * @author Sebastian Balestrini <sbalestrini@gmail.com>
 * @version 2.0
 *
 * Extensi�n del controlador para procesar las solicitudes del XADMIN
 * class RequestController: Clase que gestiona y procesa las solicitudes por REQUEST
 *
 * 	
 */
class xadmin_RequestController extends RequestController {

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

        // Seteamos el nombre del controlador	

        $this->assign("theme", THEME_ADMIN);
        define("THEME", THEME_ADMIN);
        $this->assign("url_themes", URL_ROOT . "xframework/app/themes/" . THEME . "/");

        $this->assign("TITLE", NOMBRE_SISTEMA . " v" . VERSION);
        $this->assign("VERSION", VERSION);
        //Constantes de traduccion
        define("TRADUCCION_IDIOMA", $_SESSION[URL_ROOT]['idioma']);
        $this->assign("translation_file", "translate_" . TRADUCCION_IDIOMA . ".js");
        $this->assign("TRADUCCION_DEFAULT", TRADUCCION_IDIOMA);

        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);


        if (isset($_SESSION[URL_ROOT][CONTROLLER]['allowed']) && $_SESSION[URL_ROOT][CONTROLLER]['allowed']) {

            $this->assign("allowed", "1");
            $this->assign("account", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']);

            $this->default_module = "home";
            $this->default_submodule = "home";


            $this->setLayout("maestra");
        } else {


            $this->default_module = "home";
            $this->default_submodule = "login";
            $this->setLayout("maestra_login");
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Stetea los PATHS espec�ficos de un controlador. Funciones especificas del controller. Deben ser definidas en la subclase
     * 	@return void
     */
    protected function setPath() {

        // Iconos Comunes
//			$this->assign("ICONS", URL_ROOT."view/common/imgs/xadmin/icons/"); // xadmin

        parent::setPath();
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 2.0
     * 
     * 	Determina segun la segurdad si se puede acceder a un modulo/submodulo
     * 	En caso que sea necesario, las subclases debera�n implementar esta fuci�n		
     *
     * 	@return void
     */
    protected function isAllowed() {


        if (
                (!isset($_SESSION[URL_ROOT][CONTROLLER]["allowed"]) || !isset($_SESSION[URL_ROOT][CONTROLLER]['logged_account']))
        ) {

            if (isset($this->request['fromajax']) && $this->request['fromajax'] == 1) {
                if ((!in_array($this->actual_module, array("home", "login"))) || (!in_array($this->actual_submodule, array("login", "forgot", "resetPass")))) {
                    die("access denied");
                    exit();
                }
            } else {
                if ((!in_array($this->actual_module, array("home", "login"))) || (!in_array($this->actual_submodule, array("login", "forgot", "resetPass")))) {
                    header("Location: xadmin.php");
                    exit();
                }
            }
        }

        return true;
    }

}

// end_class
?>
