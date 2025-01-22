<?php

$this->start();
$ManagerTurno=$this->getManager("ManagerTurno");
$ManagerTurno->reservar_turno_medico($this->request);


$this->finish($ManagerTurno->getMsg());