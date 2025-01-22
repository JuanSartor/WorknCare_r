<?php

//recumeramos los registros mediante el hash


$Invitacions = $this->getManager("ManagerEmpresaInvitacionCapsula")->getByField("hash", $this->request["hash"]);
$this->assign("invitacion", $Invitacions);

$capsula = $this->getManager("ManagerCapsula")->get($Invitacions["capsula_idcapsula"]);
$this->assign("capsula", $capsula);
if ($capsula["tipo_capsula"] == '1') {
    $fileCapsula = $this->getManager("ManagerFileCapsula")->getByField("capsula_idcapsula", $Invitacions["capsula_idcapsula"]);
    $this->assign("fileCapsula", $fileCapsula);
} else if ($capsula["tipo_capsula"] == '2') {
    $linkCapsula = $this->getManager("ManagerLinkCapsula")->getByField("capsula_idcapsula", $Invitacions["capsula_idcapsula"]);
    $this->assign("linkCapsula", $linkCapsula);
} else if ($capsula["tipo_capsula"] == '3') {
    $videoCapsula = $this->getManager("ManagerVideoCapsula")->getByField("capsula_idcapsula", $Invitacions["capsula_idcapsula"]);
    $this->assign("videoCapsula", $videoCapsula);
} else {
    $grabacionCapsula = $this->getManager("ManagerGrabarVideoCapsula")->getByField("capsula_idcapsula", $Invitacions["capsula_idcapsula"]);
    $this->assign("grabacionCapsula", $grabacionCapsula);
}




