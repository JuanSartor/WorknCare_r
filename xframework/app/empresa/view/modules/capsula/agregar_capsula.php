<?php

$this->assign("banderaCapsula", $this->request["banderaCapsula"]);
$managaC = $this->getManager("ManagerCapsula");
if ($this->request["idcapsula"] != '') {

    $this->assign("banderaGenerica", 1);

    $capsu = $managaC->get($this->request["idcapsula"]);
    $this->assign("capsu", $capsu);
    if ($this->request["banderaCapsula"] == '1') {
        $fileCapsu = $this->getManager("ManagerFileCapsula")->getByField("capsula_idcapsula", $this->request["idcapsula"]);
        $this->assign("fileCapsula", $fileCapsu);
    }
    if ($this->request["banderaCapsula"] == '2') {
        $fileCapsu = $this->getManager("ManagerLinkCapsula")->getByField("capsula_idcapsula", $this->request["idcapsula"]);
        $this->assign("linkCapsula", $fileCapsu);
    }
    if ($this->request["banderaCapsula"] == '3') {
        $videoCapsula = $this->getManager("ManagerVideoCapsula")->getByField("capsula_idcapsula", $this->request["idcapsula"]);
        $this->assign("videoCapsula", $videoCapsula);
        $nombreV = explode($videoCapsula["ext"], $videoCapsula["nombre"]);
        // esto tuve q hacerlo porque algunos nombres se guardan con la extension y sino me agregaba un punto de mas
        if (substr($nombreV[0], -1) == '.') {
            $this->assign("nombVideo", substr($nombreV[0], 0, -1));
        } else {
            $this->assign("nombVideo", $nombreV[0]);
        }
    }
} else {
    $this->assign("banderaGenerica", 0);
}


$cant_capsulas_lista = $managaC->cantCapsulasListas();
$this->assign("cant_capsulas_lista", $cant_capsulas_lista["cant"]);
