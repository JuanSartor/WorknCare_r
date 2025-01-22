<?php
/**
 *
 *  Prestadores List
 *
 */

$manager = $this -> getManager("ManagerPrestador");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>