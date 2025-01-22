<?php

/** 	
 * 	Accion: gestion de  Banners promocionales
 * 	
 */
$this->start();
$manager = $this->getManager("ManagerBannerPromocion");
// $manager->debug();
$result = $manager->process($this->request);
$this->finish($manager->getMsg());
