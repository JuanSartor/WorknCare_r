<?php
$ManagerConsultaExpress = $this->getManager("ManagerConsultaExpress");
$consultas_especialidad = $ManagerConsultaExpress->getCantidadConsultaExpressXEspecialidad();
$this->assign("consultas_especialidad", $consultas_especialidad);
