<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->processVideoConsultaStep1($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

