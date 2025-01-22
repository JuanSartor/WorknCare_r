<?php

$this->start();

$ManagerTurno=$this->getManager("ManagerTurno");
$ManagerTurno->paciente_nuevo_reservar_turno($this->request);


$this->finish($ManagerTurno->getMsg());