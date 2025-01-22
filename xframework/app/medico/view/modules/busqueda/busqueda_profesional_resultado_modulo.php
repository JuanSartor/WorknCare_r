<?php

if ($this->request["delete_item"] != "") {
    if ($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"][$this->request["delete_item"]]) {
        unset($_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"][$this->request["delete_item"]]);

        //Si elimino item de los tags inputs, reseteo el paginador
        $this->request["do_reset"] = 1;
    }
}


$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);

$request_anterior = (array) $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"];

$ManagerMedico = $this->getManager("ManagerMedico");
//  $ManagerMedico->print_r($request_anterior);
$request_anterior["current_page"] = $this->request["current_page"];
if ($this->request["do_reset"] == 1) {
    $request_anterior["do_reset"] = $this->request["do_reset"];
}

$listado = $ManagerMedico->getMedicosListFromBusquedaMedicoPaginado($request_anterior, $idpaginate);

$this->assign("listado_medicos", $listado);




//inicialiamos los ids de consultorio para los mapas
if ($listado["rows"] && count($listado["rows"]) > 0) {

    foreach ($listado["rows"] as $medico) {
      
        foreach ($medico["list_consultorios"] as $consultorio) {
            
            if ($consultorio["idconsultorio"] != "" && $consultorio["is_virtual"]=="0") {
              
                $id_cons = $consultorio["idconsultorio"];
                $id_consultorios .= "$id_cons,";
            }
        }
    }

    if (strlen($id_consultorios) > 0) {
        $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
    }
    $this->assign("id_consultorios", $id_consultorios);
}

