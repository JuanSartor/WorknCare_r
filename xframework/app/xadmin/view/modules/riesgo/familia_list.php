<?php

/**
 *
 *  Cuestionarios
 *
 */
$manager = $this->getManager("ManagerFamiliaRiesgo");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
