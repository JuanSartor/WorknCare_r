<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->processVideoConsultaStep2ProfesionalFrecuente($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

