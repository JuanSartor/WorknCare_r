<?php

//print($this->request["id"]);
$this->start();
$Manager = $this->getManager("ManagerCuestionario");
$cuestionario = $Manager->get($this->request["id"]);

$ManagerPre = $this->getManager("ManagerPregunta");
$cantidadPreguntas = $ManagerPre->getCantidadPreguntas($cuestionario["idcuestionario"]);

$cuestionario["cantidadPreguntas"] = $cantidadPreguntas["cantidad"];
$Manager->getReportePDF($cuestionario);
