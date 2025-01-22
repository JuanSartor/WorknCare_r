<?php

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$videoconsulta_reintegro=$ManagerVideoConsulta->get_consulta_reintegro_detalle($this->request["id"]);
//print_r($videoconsulta_reintegro);
$this->assign("videoconsulta", $videoconsulta_reintegro);




