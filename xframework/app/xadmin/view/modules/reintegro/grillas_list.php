<?php
/**
 *
 *  Grillas List
 *
 */

$manager = $this -> getManager("ManagerGrilla");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);


  
  
?>