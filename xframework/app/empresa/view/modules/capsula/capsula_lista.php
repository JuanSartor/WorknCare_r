<?php

$managaC = $this->getManager("ManagerEmpresaInvitacionCapsula");
$capsula_lista = $managaC->getCapsulaByHash($this->request["id"]);

$this->assign("capsula_lista", $capsula_lista);

if ($capsula_lista["tipo_capsula"] == '2') {
    $linkCapsula = $this->getManager("ManagerLinkCapsula")->getByField("capsula_idcapsula", $capsula_lista["idcapsula"]);
    $this->assign("linkCapsula", $linkCapsula);
}

