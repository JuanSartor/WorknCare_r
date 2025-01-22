<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->cancelarPago($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

