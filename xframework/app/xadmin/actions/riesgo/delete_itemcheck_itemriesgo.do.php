<?php

/**
 *  elimino el registro de la tabla pregunta asociado a un cuestionario
 */
$this->start();


$manager = $this->getManager("ManagerItemCheckRiesgo");

// $manager->debug();
$result = $manager->delete($this->request["id_check_itemriesgo"], true);
$this->finish($manager->getMsg());


