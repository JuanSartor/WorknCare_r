<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->posponerVideoConsulta($this->request);
$this->finish($ManagerVideoConsulta->getMsg());