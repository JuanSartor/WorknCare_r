<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->aceptarVideoConsulta($this->request);
$this->finish($ManagerVideoConsulta->getMsg());