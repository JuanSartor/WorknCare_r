<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->process_vencimiento_espera_videoconsulta($this->request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());