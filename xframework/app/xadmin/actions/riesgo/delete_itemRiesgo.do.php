<?php

/**
 *  elimino el registro de la tabla pregunta asociado a un cuestionario
 */
$this->start();


$manager = $this->getManager("ManagerItemRiesgo");

// $manager->debug();
$result = $manager->deleteItem($this->request["idItemRiesgo"]);
$this->finish($manager->getMsg());


