<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");

$result=$ManagerVideoConsulta->createVideoConsultaByMedico($this->request["medico_idmedico"]);
$this->finish($ManagerVideoConsulta->getMsg());


