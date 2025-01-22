<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los Las ópticas
 *
 */
class ManagerOpticas extends ManagerAccounts {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "farmacia", "idfarmacia");
        $this->login_field = "email";
        $this->password_field = "password";
        /*
          $this->setImgContainer("medicos");
          $this->addImgType("jpg");
          $this->addThumbConfig(64, 64, "_th"); 
         */
    }

    public function getTagsBusquedaOpticas() {
        $managerEspecialidades = $this->getManager("ManagerEspecialidades");
        $managerObraSocial = $this->getManager("ManagerObrasSociales");
        $managerProvincia = $this->getManager("ManagerProvincia");

        $busqueda_opticas = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_opticas'];

        $tags_inputs = "";
        if (isset($busqueda_opticas["nombre"]) && $busqueda_opticas["nombre"] != "") {
            $tags_inputs.="," . $busqueda_opticas["nombre"];
        }
        if (isset($busqueda_opticas["idobra_social"]) && $busqueda_opticas["idobra_social"]) {
            $obraSocial = $managerObraSocial->get($busqueda_opticas["idobra_social"]);
            $tags_inputs.="," . $obraSocial["nombre"];
        }
        if (isset($busqueda_opticas["idprovincia"]) && $busqueda_opticas["idprovincia"] != "") {
            $provincia = $managerProvincia->get($busqueda_opticas["idprovincia"]);
            $nombre_prov = str_replace(",", "", $provincia["provincia"]);
            $tags_inputs.="," . $nombre_prov;
        }
        if (isset($busqueda_opticas["as_localidad"]) && $busqueda_opticas["as_localidad"] != "") {
            $tags_inputs.="," . str_replace(",", "", $busqueda_opticas["as_localidad"]);
        }
        if (isset($busqueda_opticas["idespecialidad"]) && $busqueda_opticas["idespecialidad"] != "") {
            $especialidad = $managerEspecialidades->get($busqueda_opticas["idespecialidad"]);
            $tags_inputs.="," . $especialidad["especialidad"];
        }

        return $tags_inputs;
    }

}

//END_class
?>