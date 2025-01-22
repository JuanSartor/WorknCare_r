<?php

$paginate = "profesionales_red_list";

$this->assign("idpaginate", $paginate);
$ManagerFiltroBusqueda = $this->getManager("ManagerFiltrosBusquedaConsultaExpress");


$medicos_list = $ManagerFiltroBusqueda->getListadoPaginadoMedicosBolsa($this->request, $paginate);



if ($medicos_list) {
    $this->assign("medicos_list", $medicos_list);
}


/**
 * Los id´s de los consultorios
 */
if ($medicos_list["rows"] && count($medicos_list["rows"]) > 0) {
    foreach ($medicos_list["rows"] as $key => $value) {
        if ($value["idconsultorio"] != "") {
            $id_cons = $value["idconsultorio"];
            $id_consultorios .= "$id_cons,";
        }
    }

    if (strlen($id_consultorios) > 0) {
        $id_consultorios = substr($id_consultorios, 0, strlen($id_consultorios) - 1);
    }
    $this->assign("id_consultorios", $id_consultorios);
}