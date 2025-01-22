<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$result=$ManagerVideoConsulta->publicarVideoConsulta($this->request);
$this->finish($ManagerVideoConsulta->getMsg());

