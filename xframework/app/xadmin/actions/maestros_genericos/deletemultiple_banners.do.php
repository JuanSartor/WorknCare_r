<?php

/** 	
 * 	Accion: Eliminacion mutiple de banners
 *
 *
 */
$manager = $this->getManager("ManagerBannerPromocion");

$manager->deleteMultiple($this->request['ids'], true);

$this->finish($manager->getMsg());
