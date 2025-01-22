<?php

$this->start();
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$ManagerEmpresa->getCuestionarioPassFlayer($this->request);
?>