<?php
/**
 *
 *  EmabajadorList
 *
 */

$manager = $this -> getManager("ManagerProgramaSaludCupon");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>