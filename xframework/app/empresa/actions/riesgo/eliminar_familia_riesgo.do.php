<?php

/**
 *  elimino la pregunto y actualizo si hay algun input con algun dato
 */
$idp = $this->request["idfamilia_riesgo"];
if ($this->request["idempresa"] != '0') {

    $managerMod = $this->getManager("ManagerModeloRiesgo");
    $rqUpdaModelo["nombre"] = $this->request["titulo"];
    $rqUpdaModelo["nombre_en"] = $this->request["titulo"];
    $rqUpdaModelo["descripcion_observacion"] = $this->request["descripcionModelo"];
    $managerMod->update($rqUpdaModelo, $this->request["idmodelos_riesgos"]);


    $managerFam = $this->getManager("ManagerFamiliaRiesgo");
    $managerFam->deleteFamiliaAsociadaAModelo($this->request["idfamilia_riesgo"], $this->request["idmodelos_riesgos"]);
    $this->finish($managerFam->getMsg());
} else {
    $managerMod = $this->getManager("ManagerModeloRiesgo");
    $managerMod->crearModeloEmpresaConEliminacion($this->request);
    $this->finish($managerMod->getMsg());
}



