<?php

/**
 *  Action para actualizar la columna  notificacion_completardatos en la tabla paciente
 */
$ManagerPaciente = $this->getManager("ManagerPaciente");
$ManagerPaciente->basic_update(["notificacion_completardatos" => 1], $this->request["idpaciente"]);
$this->finish($ManagerPaciente->getMsg());
