<?php
/**
 *
 *  PlanesList
 *
 */

$manager = $this -> getManager("ManagerProgramaSaludPlan");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>