<?php
/**
 *
 *  Banners promocionales
 *
 */
$manager = $this -> getManager("ManagerBannerPromocion");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);