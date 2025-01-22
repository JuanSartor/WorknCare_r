<?php

$this->start();
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$ManagerEmpresa->getCuestionarioPassFlayerCapsula($this->request);
?>