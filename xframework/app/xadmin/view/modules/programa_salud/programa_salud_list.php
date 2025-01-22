<?php
/**
 *
 *  Programas de salud
 *
 */

$manager = $this -> getManager("ManagerProgramaSalud");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
