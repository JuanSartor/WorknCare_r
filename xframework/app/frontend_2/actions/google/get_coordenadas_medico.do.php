<?php

/**
 * ACCIÓN que obtiene las coordenadas de un medico
 */
if (isset($this->request["idmedico"]) && $this->request["idmedico"] != "") {
    $ManagerDireccion = $this->getManager("ManagerDireccion");

    $direccion = $ManagerDireccion->getDireccionToGoogleMap($this->request["idmedico"]);
    $direcciones = $direccion;


    $location = "France"; //Lugar donde se va a centrar el mapa de Google Map

    $direcciones["zoom"] = "10";


    $loc = geocoder::getLocation($location);


    if ($loc["lat"] != "" && $loc["lng"] != "") {
        $direcciones["lat"] = $loc["lat"];
        $direcciones["lng"] = $loc["lng"];
    } else {
        $direcciones["lat"] = "48.864716";
        $direcciones["lng"] = "2.349014";
    }
} else {

    $location = "France";


    $idlocalidad = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_profesionales']['idlocalidad'];
    if ($idlocalidad != "") {
        $localidad = $this->getManager("ManagerLocalidad")->get($idlocalidad);
        $location .= ", " . $localidad["localidad"] . ", " . $localidad["cpa"];
    }

    $loc = geocoder::getLocation($location);


    $direcciones = array(
        "lat" => $loc["lat"],
        "lng" => $loc["lng"],
        "zoom" => "5",
        "no_idconsultorios" => true
    );

    if ($loc["lat"] == "" && $loc["lng"] == "") {
        $direcciones["lat"] = "48.864716";
        $direcciones["lng"] = "2.349014";
    }
}


echo json_encode($direcciones);

