<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerTipoAlergia");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>