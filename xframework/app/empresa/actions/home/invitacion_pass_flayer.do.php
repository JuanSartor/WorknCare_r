<?php

$this->start();
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$ManagerEmpresa->getInvitacionPassFlayer($this->request);
?>