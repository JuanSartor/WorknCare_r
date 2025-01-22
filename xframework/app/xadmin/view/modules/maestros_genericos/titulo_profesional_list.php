<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerTituloProfesional");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
