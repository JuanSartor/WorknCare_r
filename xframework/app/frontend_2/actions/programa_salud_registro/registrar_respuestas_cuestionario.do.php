<?php

$this->start();
//print_r($this->request);
//die();
if ($this->request["respuestasAbiertas"] != '') {
    $managerRtasAbiertas = $this->getManager("ManagerRespuestasAbiertasCuestionario");
    $this->request["fecha_registrada_respuestas"] = date("Y-m-d");
    $managerRtasAbiertas->registrarRtasAbiertas($this->request);
}

$manager = $this->getManager("ManagerRespuestasCuestionario");
$this->request["fecha_registrada_respuestas"] = date("Y-m-d");
$manager->process($this->request);
$this->finish($manager->getMsg());
