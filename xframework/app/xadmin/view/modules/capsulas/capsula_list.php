<?php

/**
 *
 *  Cuestionarios
 *
 */
$manager = $this->getManager("ManagerCapsula");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
