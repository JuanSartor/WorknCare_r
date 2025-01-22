<?php

/** 	
 * 	Accion: Grilla del Listado de Banners
 * 	
 */
// ini_set('display_errors','1');
//error_reporting(6143);
$manager = $this->getManager("ManagerBannerPromocion");
//$manager->debug();
$records = $manager->getListadoJSON($this->request, $manager->getDefaultPaginate());

echo $records;
