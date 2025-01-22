<?php

    /** 	
 * 	Accion: Envío de invitación de Paciente
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerInformacionComercialMedico");

//$manager->debug();
$result = $manager->processFromFrontEnd($this->request);


$this->finish($manager->getMsg());

