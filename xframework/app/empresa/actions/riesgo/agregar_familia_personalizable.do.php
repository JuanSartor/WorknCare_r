<?php

//print_r($this->request);
//die();
if ($this->request["idempresa"] == '0' || $this->request["idempresa"] == '') {
// creo el modelo y agrego la nueva familia agregada
    $managerM = $this->getManager("ManagerModeloRiesgo");
    $managerM->crearModeloEmpresaSinEliminacion($this->request);
    $this->finish($managerM->getMsg());
} else {
// aca solamente inserto la familia nueva y actualizo los datos de modelo si hubo cambio


    $managerMod = $this->getManager("ManagerModeloRiesgo");
    $rqUpdaModelo["nombre"] = $this->request["nombre"];
    $rqUpdaModelo["nombre_en"] = $this->request["nombre"];
    $rqUpdaModelo["descripcion_observacion"] = $this->request["descripcionModelo"];
    $managerMod->update($rqUpdaModelo, $this->request["idmodelos_riesgos"]);

    $managerf = $this->getManager("ManagerFamiliaRiesgo");
    $managerf->insertarFamilia($this->request);

    $this->finish($managerf->getMsg());
}