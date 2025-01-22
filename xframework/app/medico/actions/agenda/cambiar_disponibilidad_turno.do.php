<?php

//accion para  cambiar estado a turno


$ManagerCambioDisponibilidad = $this->getManager("ManagerTurno");

$ManagerCambioDisponibilidad->cambiarDisponibilidad($this->request);

$this->finish($ManagerCambioDisponibilidad->getMsg());
