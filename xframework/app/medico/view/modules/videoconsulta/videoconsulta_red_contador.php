<?php
$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$consultas_especialidad = $ManagerVideoConsulta->getCantidadVideoConsultaXEspecialidad();
$this->assign("consultas_especialidad", $consultas_especialidad);

