<?php

$manager = $this->getManager("ManagerLog");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
?>