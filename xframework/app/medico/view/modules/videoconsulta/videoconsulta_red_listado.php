<?php

//Consulta en la Red


$idmedico = $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"];


$this->assign("idmedico", $idmedico);



$idpaginate = "listado_paginado_videoconsultas_red_{$idmedico}";
$this->assign("idpaginate", $idpaginate);

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$listado = $ManagerVideoConsulta->getListadoPaginadoVideoConsultasRed($this->request, $idpaginate);

if (count($listado["rows"]) > 0) {
    $this->assign("listado_videoconsultas_red", $listado);
} else {
    //obtenemos si existió alguna consulta en la red asociada y ya no existe, para mostrar un alerta
    $consulta_red_historica = $ManagerVideoConsulta->getHistoricoVideoConsultasRed($this->request, $idpaginate);
    if ($consulta_red_historica > 0) {
        $this->assign("consulta_red_historica", $consulta_red_historica);
    }
}


  