<?php

$this->start();
$ManagerInv = $this->getManager("ManagerEmpresaInvitacionCuestionario");
$inv = $ManagerInv->getByField("cuestionario_idcuestionario", $this->request["id"]);

$reque["id"] = $inv["hash"];

$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$ManagerEmpresa->getCuestionarioPassFlayer($reque);
?>