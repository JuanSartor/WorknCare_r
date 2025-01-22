<?php

$this->start();
$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->obtener_contador_videoconsultas_socket();
$this->finish($ManagerVideoConsulta->getMsg());
