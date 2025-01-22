<?php

$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);

$request_anterior = (array) $_SESSION[URL_ROOT][CONTROLLER]["request_busqueda_medico"];

$ManagerMedico = $this->getManager("ManagerMedico");
//  $ManagerMedico->print_r($request_anterior);
$request_anterior["current_page"] = $this->request["current_page"];
if ($this->request["do_reset"] == 1) {
    $request_anterior["do_reset"] = $this->request["do_reset"];
}
$listado = $ManagerMedico->getMedicosListFromBusquedaExterna($request_anterior, $idpaginate);

//marcamos el programa seleccionado
$this->assign("idprograma_categoria_seleccionado", $request_anterior["idprograma_categoria"]);



//inicialiamos los ids de consultorio para los mapas
if ($listado["rows"] && count($listado["rows"]) > 0) {
    $id_consultorios = "";
    foreach ($listado["rows"] as $key => $value) {
        if ($value["idconsultorio"] != "") {
            $id_consultorios .= "{$value["idconsultorio"]},";
        }

        if ($value["list_consultorios"] != "") {
            foreach ($value["list_consultorios"] as $consultorio) {
                if ($value["idconsultorio"] != "") {
                    $id_consultorios .= "{$consultorio["idconsultorio"]},";
                }
            }
        }
        //verificamos sl consultorio es virutal
        if ($value["is_virtual"] == 1) {

            //$preferencia = $this->getManager("ManagerPreferencia")->getPreferenciaMedico($value["medico_idmedico"]);
        }
    }

    if (strlen($id_consultorios) > 0) {
        $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
    }
    $this->assign("id_consultorios", $id_consultorios);
}
$this->assign("listado_consultorios", $listado);

// obtengo el id del programa mediante la categoria
$ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");
$ProgramaSaludCategoria = $ManagerProgramaSaludCategoria->get($request_anterior["idprograma_categoria"]);
$idProgramaSalud = $ProgramaSaludCategoria["programa_salud_idprograma_salud"];

// obtengo el programa salud
$ManagerProgramaSalud = $this->getManager("ManagerProgramaSalud");
$this->assign("programa_salud", $ManagerProgramaSalud->get($idProgramaSalud));
