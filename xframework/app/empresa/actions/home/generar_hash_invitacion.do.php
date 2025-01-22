<?php

/** 	
 * 	Accion: genera otro hash de invitacion y codigo del pass
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");


$result = $manager->generar_hash_invitacion($this->request);
$this->finish($manager->getMsg());

