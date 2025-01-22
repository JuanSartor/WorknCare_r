<?php
/**
 *
 *  Grupos de Programas de salud
 *
 */

$manager = $this -> getManager("ManagerProgramaSaludGrupo");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
