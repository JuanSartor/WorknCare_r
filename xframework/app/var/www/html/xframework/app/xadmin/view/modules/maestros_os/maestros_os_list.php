<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerObrasSociales");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>