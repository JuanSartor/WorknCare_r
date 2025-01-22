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
class farmacia_RequestController extends RequestController {

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
        $this->loadClasses(path_managers("extensions"), NULL);
        $this->loadClasses(path_helpers("extensions"), NULL);
        //Constantes de traduccion
        $this->assign("translation_file", "translate_" . TRADUCCION_DEFAULT . ".js");
        $this->assign("TRADUCCION_DEFAULT", TRADUCCION_DEFAULT);

        $this->default_module = "home";
        $this->default_submodule = "index";
        $this->setLayout("maestra");



        $action = 0;
        if ($this->isAction()) {
            $action = 1;
        }




        $this->setSeo(true);
    }

    /**
     * get seo
     *
     * */
    public function getSeo() {


        $seo = array(
            "meta_title" => "DoctorPlus | Ordonnance",
            "meta_keywords" => "téléconsultation,télémédecine,téléexpertise,vidéo consultation, médecin,rendez-vous, doctorplus, ordonnance, spécialiste, patient,experts en santé,programmes de santé",
            "meta_description" => "Plus de 100 professionnels experts en santé, social et bien-être accessibles par vidéo et tchat. Nous vous aidons à résoudre un problème ou tout simplement vous sentir mieux!"
        );

        return $seo;
    }

}

// end_class
?>
