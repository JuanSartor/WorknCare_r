<?php
/**
 *
 *  Motivos de Consulta Express
 *
 */

$manager = $this -> getManager("ManagerMotivoRechazo");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
