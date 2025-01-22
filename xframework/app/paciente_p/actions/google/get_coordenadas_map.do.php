<?php

/**
 * ACCIÓN que obtiene las coordenadas de unos consultorios
 */
/**
 * Si vienen los ids de los consultorios que se desean ubicar dentro del map
 * vienen separados por ','
 */
if (isset($this->request["id_consultorios"]) && $this->request["id_consultorios"] != "") {

    $managerConsultorio = $this->getManager("ManagerConsultorio");
    
    $direcciones = $managerConsultorio->getListConsultorioToGoogleMap($this->request["id_consultorios"]);

    //Me fijo si hay una provincia cargada en los filtros de búsqueda.
    $idprovincia = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_profesionales']['idprovincia'];


    $location = "France"; //Lugar donde se va a centrar el mapa de Google Map
    //Si en la búsqueda hay ID de provincia
    if ($idprovincia != "") {
        $provincia = $this->getManager("ManagerProvincia")->get($idprovincia);
        $location .= ", " . $provincia["provincia"];
        $localidad = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']['busqueda_profesionales']['as_localidad'];
        $direcciones["zoom"] = "10";

        if ($localidad != "") {
            $direcciones["zoom"] = "11";
            $location .= ", " . $localidad;
        }
    } else {
        //$location .= ", Buenos Aires, Buenos Aires";
        $direcciones["zoom"] = "5";
    }

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

