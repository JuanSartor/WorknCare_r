<?php

/**
 * @author Sebastian Balestrini <sbalestrini@gmail.com>
 * @version 2.0
 *
 * Extensi�n del controlador para procesar las solicitudes de COMMON
 * class RequestController: Clase que gestiona y procesa las solicitudes por REQUEST
 *
 * 	
 */
class common_RequestController extends RequestController {

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

        // Codigo
        define("THEME", "dp02");
        $this->assign("url_themes", URL_ROOT . "xframework/app/themes/" . THEME . "/");
        $this->assign("VIDEOCONSULTA_VENCIMIENTO_SALA", VIDEOCONSULTA_VENCIMIENTO_SALA);
        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);
        $this->assign("GOOGLE_MAPS_KEY", GOOGLE_MAPS_KEY);
       
    }

}

// end_class
?>
