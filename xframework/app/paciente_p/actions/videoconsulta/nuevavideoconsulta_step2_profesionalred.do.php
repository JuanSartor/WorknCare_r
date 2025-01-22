<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->processVideoConsultaStep2ProfesionalRed($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

