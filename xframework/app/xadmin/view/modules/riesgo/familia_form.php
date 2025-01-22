<?php

/**
 *  cuestionarios
 *  
 * */
$ManagerFamCuest = $this->getManager("ManagerModeloRiesgo");
$this->assign("familias", $ManagerFamCuest->getCombo());

$ManagerM = $this->getManager("ManagerModeloRiesgo");
$todosLosModelos = $ManagerM->getListadoModelos();


if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerFamiliaRiesgo");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

    $ids = explode(",", $record["modelos_riesgo_idmodelos_riesgo"]);


    $managerE = $this->getManager("ManagerEmpresa");
    $empresa = $managerE->get($record["empresa_idempresa"]);
    $this->assign("empresa", $empresa);
}


foreach ($todosLosModelos as $key => $elemento) {
    if (in_array($elemento["idmodelos_riesgos"], $ids)) {
        $todosLosModelos[$key]["chck"] = 1;
    } else {
        $todosLosModelos[$key]["chck"] = 0;
    }
}


$this->assign("modelos", $todosLosModelos);
