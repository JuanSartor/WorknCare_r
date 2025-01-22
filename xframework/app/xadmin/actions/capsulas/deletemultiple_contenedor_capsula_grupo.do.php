<?php

/**
 *  elimino el cuestionaio pero desde la familia
 */
$this->start();
$manager = $this->getManager("ManagerContenedorCapsula");


$result = $manager->deleteContenedor($this->request["ids"]);
$this->finish($manager->getMsg());
