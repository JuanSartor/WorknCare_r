<?php

/** 	
 * 	Accion: cambia el estado de la relacion medico con prestador
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerMedicoPrestador");
//$manager->debug();
$result = $manager->update(["estado"=>1],$this->request["id"]);
$this->finish($manager->getMsg());
?>
