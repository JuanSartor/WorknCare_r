<?php

$this->start();
$ManagerInv = $this->getManager("ManagerEmpresaInvitacionCapsula");
$inv = $ManagerInv->getByField("capsula_idcapsula", $this->request["id"]);

$reque["id"] = $inv["hash"];

$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$ManagerEmpresa->getCuestionarioPassFlayerCapsula($reque);
?>