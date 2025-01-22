<?php
/**
 *
 * Tags List
 *
 */

$manager = $this -> getManager("ManagerTags");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);

?>