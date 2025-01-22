<?php
/**
 *
 *  Motivos de Consulta Express
 *
 */

$manager = $this -> getManager("ManagerMotivoVideoConsulta");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
