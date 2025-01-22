<?php

/**
 *
 *  Cuestionarios
 *
 */
$manager = $this->getManager("ManagerItemRiesgo");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
