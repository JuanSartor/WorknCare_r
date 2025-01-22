<?php

$ManagerVideoConsulta = $this->getManager("ManagerVideoConsulta");


$ManagerVideoConsulta->back_step($this->request);


$this->finish($ManagerVideoConsulta->getMsg());

