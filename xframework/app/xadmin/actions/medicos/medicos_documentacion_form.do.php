<?php

/** 	
 * 	Accion: Adjuntar documentacion de medicos
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerDocumentacionMedico");

$result = $manager->process($this->request);
$this->finish($manager->getMsg());
?>