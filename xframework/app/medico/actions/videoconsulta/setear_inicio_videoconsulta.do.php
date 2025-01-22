<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->iniciarLlamada($this->request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());