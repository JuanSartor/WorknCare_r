<?php

/**
 *
 *  Cuestionarios
 *
 */
$manager = $this->getManager("ManagerCuestionario");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
