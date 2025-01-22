<?php
$this->start();
$ManagerTurno=$this->getManager("ManagerTurno");
$ManagerTurno->habilitarTurnoFromMedico($this->request["idturno"]);
$this->finish($ManagerTurno->getMsg());