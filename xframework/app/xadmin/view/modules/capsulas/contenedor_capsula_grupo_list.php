<?php

/**
 *
 *  List Familia de cuestionarios
 *
 */
$manager = $this->getManager("ManagerContenedorCapsula");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
