<?php

/**
 *  actualizo la pregunta y tambien si hay algo en los inputs lo guardo
 */
if ($this->request["idempresa"] == '0') {

    $managerM = $this->getManager("ManagerModeloRiesgo");
    $managerM->crearModeloEmpresaConActualizacionFamilia($this->request);
    $this->finish($managerM->getMsg());
} else {
    // ace entra cuando la edicion es sobre una familia pero es un modelo ya asociado a una empresa
    $managerMod = $this->getManager("ManagerModeloRiesgo");
    $managerMod->actualizarModeloYFamiliaYaAsociada($this->request);
    $this->finish($managerMod->getMsg());
}
