<?php

/**
 *
 *  List Familia de cuestionarios
 *
 */
$manager = $this->getManager("ManagerTextoAuxiliares");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
