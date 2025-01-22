<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->notificarMedicoEnSala($this->request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());
