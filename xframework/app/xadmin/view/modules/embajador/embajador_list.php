<?php
/**
 *
 *  EmabajadorList
 *
 */

$manager = $this -> getManager("ManagerEmbajador");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>