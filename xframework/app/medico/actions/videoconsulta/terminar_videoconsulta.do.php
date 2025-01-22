<?php

/* 
 * Metodo que finaliza la consulta (estado=8) cuando termina la llamada el medico
 * y deja pendiente el cierre de la consulta medica
 */

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$ManagerVideoConsulta->terminarVideoConsulta($this->request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());