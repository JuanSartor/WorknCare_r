<?php

$ManagerCuestionario = $this->getManager("ManagerModeloRiesgo");

$cantMisModelos = $ManagerCuestionario->getCantidadMisModelos();
$this->assign("cantMisModelos", $cantMisModelos["cantidad"]);


$cantModelosGenericos = $ManagerCuestionario->getCantidadModelosGenericos();
$this->assign("cantModelosGenericos", $cantModelosGenericos["cantidad"]);
