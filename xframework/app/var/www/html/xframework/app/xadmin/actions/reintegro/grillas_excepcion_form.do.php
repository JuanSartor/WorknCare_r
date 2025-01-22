<?php

/** 	
 * 	Accion: Aagregar excepciones a las grillas
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerGrillaExcepcion");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>