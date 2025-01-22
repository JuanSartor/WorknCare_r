<?php

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$idpaginate = "listado_videoconsultas_reintegro";


$this->assign("idpaginate", $idpaginate);
$this->request["do_reset"] = 1;
$videoconsultas_reintegro = $ManagerVideoConsulta->get_listado_consultas_reintegro($this->request, $idpaginate);

$this->assign("videoconsultas_reintegro", $videoconsultas_reintegro);

//asignamos los filtro de la busqueda si vienen seteados
if ($this->request["filtro_inicio"] != "") {

    $this->assign("filtro_inicio", $this->request["filtro_inicio"]);
}
if ($this->request["filtro_fin"] != "") {
    $this->assign("filtro_fin", $this->request["filtro_fin"]);
}


$cantidad = $ManagerVideoConsulta->get_cantidad_consultas_reintegro_pendiente();

$this->assign("cantidad", $cantidad);




