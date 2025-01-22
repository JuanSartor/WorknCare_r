<?php

/**
 *
 *  listado de reembolsos
 *
 */
$manager = $this->getManager("ManagerReembolso");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
