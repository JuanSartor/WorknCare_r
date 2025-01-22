<?php
/**
 *
 *  Pacientes List
 *
 */

$manager = $this -> getManager("ManagerPaciente");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>