<?php

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");

$ManagerVideoConsulta->set_medico_videoconsulta($this->request);


 $this->finish($ManagerVideoConsulta->getMsg());