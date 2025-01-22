<?php

/**
 *  modulo para obtener todos las preguntas del cuestionario
 */
$ManagerPegunta = $this->getManager("ManagerItemCheckRiesgo");

$items = $ManagerPegunta->getListadoItemsCheck(["item_riesgo_iditemriesgo" => $this->request["item_riesgo_iditemriesgo"]]);



$this->assign("items", $items);


