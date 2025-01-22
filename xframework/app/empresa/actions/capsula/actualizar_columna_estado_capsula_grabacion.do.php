<?php

$grabacion = $this->getManager("ManagerGrabarVideoCapsula")->get($this->request["idGrabacion"]);

$managerCues = $this->getManager("ManagerCapsula");
$requestCapsula["fecha_inicio"] = date("Y-m-d");
$requestCapsula["estado"] = '1';
$managerCues->update($requestCapsula, $grabacion["capsula_idcapsula"]);
$this->finish($managerCues->getMsg());


