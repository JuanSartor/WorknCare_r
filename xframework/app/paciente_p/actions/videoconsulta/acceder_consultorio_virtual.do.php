<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->acceder_consultorio_virtual($this->request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());