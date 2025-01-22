<?php
/**
 *
 *  Prestadores List
 *
 */

$manager = $this -> getManager("ManagerPlanPrestador");
$combo_plan_prestador=$manager->getComboPlanes($this->request["idprestador"]);


$this -> assign("combo_plan_prestador", $combo_plan_prestador);
?>