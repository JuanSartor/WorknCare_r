<?php

/**
 *  elimino el cuestionaio pero desde la familia
 */
$this->start();
$manager = $this->getManager("ManagerCuestionario");

// $manager->debug();
$result = $manager->deleteCuestionario($this->request["idcuestionario"]);
$this->finish($manager->getMsg());
