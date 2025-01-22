<?php

$manager=$this->getManager("ManagerVideoConsulta");
$manager->cancelarVideoConsultaPendienteFinalizacionPaciente($this->request["idvideoconsulta"]);

 $this->finish($manager->getMsg());