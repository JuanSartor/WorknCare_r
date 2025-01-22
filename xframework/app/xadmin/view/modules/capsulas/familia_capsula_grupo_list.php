<?php

/**
 *
 *  List Familia de cuestionarios
 *
 */
$manager = $this->getManager("ManagerFamiliaCapsula");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
