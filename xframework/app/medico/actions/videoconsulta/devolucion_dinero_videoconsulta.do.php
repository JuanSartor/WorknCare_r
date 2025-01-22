<?php
$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->devolverDinero($this->request);
$this->finish($ManagerVideoConsulta->getMsg());