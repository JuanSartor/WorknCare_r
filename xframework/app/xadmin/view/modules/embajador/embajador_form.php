<?php

/**
 *  Emabajadores - registros - nuevo/editar
 *  
 * */
if (isset($this->request["id"]) && (int) $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerEmbajador");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);
    //listado empresas asociadas
    $listado_empresas = $manager->getListadoEmpresas($this->request["id"]);
    $this->assign("listado_empresas", $listado_empresas);
}
?>