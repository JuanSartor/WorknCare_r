<?php

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");
$result = $ManagerVideoConsulta->confirmarPago($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

