<?php

/**
 *
 *  List Familia de cuestionarios
 *
 */
$manager = $this->getManager("ManagerFamiliaCuestionario");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
