<?php
$idpaginate = "paginacion_medico";
$this->assign("idpaginate", $idpaginate);
if (isset($this->request["idprograma_salud"]) && $this->request["idprograma_salud"] != "") {
    $programa = $this->getManager("ManagerProgramaSalud")->get($this->request["idprograma_salud"]);
    $this->assign("programa", $programa);
    $listado_categorias = $this->getManager("ManagerProgramaSaludCategoria")->getListadoCategorias($this->request["idprograma_salud"]);
    $this->assign("listado_categorias", $listado_categorias);
}
