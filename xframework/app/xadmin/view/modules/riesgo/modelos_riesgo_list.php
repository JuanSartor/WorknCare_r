<?php

/**
 *
 *  List Familia de cuestionarios
 *
 */
$manager = $this->getManager("ManagerModeloRiesgo");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
