<?php

/**
 *  modulo para obtener todos las preguntas del cuestionario
 */
$ManagerPegunta = $this->getManager("ManagerItemRiesgo");

$items = $ManagerPegunta->getListadoItems($this->request);



$this->assign("items", $items);


