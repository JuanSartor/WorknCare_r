<?php

/**
 *  cuestionarios
 *  
 * */
if (isset($this->request["id"]) && $this->request["id"] > 0) {
    $manager = $this->getManager("ManagerCuestionario");
    $record = $manager->get($this->request["id"]);

    $this->assign("record", $record);

    $ManagerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
    $pago = $ManagerPago->getByField("cuestionario_idcuestionario", $this->request["id"]);
    $this->assign("pago", $pago);

    $managerE = $this->getManager("ManagerEmpresa");
    $empresa = $managerE->get($record["empresa_idempresa"]);
    $this->assign("empresa", $empresa);
}


$ManagerFamCuest = $this->getManager("ManagerFamiliaCuestionario");
$this->assign("familias", $ManagerFamCuest->getCombo());
