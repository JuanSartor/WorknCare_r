<?php
/**
 *
 *  Motivos de Consulta Express
 *
 */

$manager = $this -> getManager("ManagerMotivoConsultaExpress");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
