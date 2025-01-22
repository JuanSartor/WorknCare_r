<?php

/**
 *  agrego una pregunta al cuestionario
 */
$this->start();

$manager = $this->getManager("ManagerItemCheckRiesgo");
//$manager->debug();
$manager->process($this->request);
$this->finish($manager->getMsg());


