<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	29/05/2014
 * 	Manager de Los médicos
 *
 */
class ManagerFarmacias extends ManagerAccounts {

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
          $this->addThumbConfig(64, 64, "_th"); */
    }

    public function getTagsBusquedaFarmacias() {
        $managerEspecialidades = $this->getManager("ManagerEspecialidades");
        $managerObraSocial = $this->getManager("ManagerObrasSociales");
        $managerProvincia = $this->getManager("ManagerProvincia");


        $busqueda_farmacia = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_farmacias'];

        $tags_inputs = "";
        if (isset($busqueda_farmacia["nombre"]) && $busqueda_farmacia["nombre"] != "") {
            $tags_inputs.="," . $busqueda_farmacia["nombre"];
        }
        if (isset($busqueda_farmacia["idobra_social"]) && $busqueda_farmacia["idobra_social"]) {
            $obraSocial = $managerObraSocial->get($busqueda_farmacia["idobra_social"]);
            $tags_inputs.="," . $obraSocial["nombre"];
        }
        if (isset($busqueda_farmacia["idprovincia"]) && $busqueda_farmacia["idprovincia"] != "") {
            $provincia = $managerProvincia->get($busqueda_farmacia["idprovincia"]);
            $nombre_prov = str_replace(",", "", $provincia["provincia"]);
            $tags_inputs.="," . $nombre_prov;
        }
        if (isset($busqueda_farmacia["as_localidad"]) && $busqueda_farmacia["as_localidad"] != "") {
            $tags_inputs.="," . str_replace(",", "", $busqueda_farmacia["as_localidad"]);
        }
        if (isset($busqueda_farmacia["idespecialidad"]) && $busqueda_farmacia["idespecialidad"] != "") {
            $especialidad = $managerEspecialidades->get($busqueda_farmacia["idespecialidad"]);
            $tags_inputs.="," . $especialidad["especialidad"];
        }
        
        return $tags_inputs;
    }

}

//END_class
?>