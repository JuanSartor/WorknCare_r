<?php
/**
 *
 *  planes de las obras Sociales List
 *
 */

$manager = $this -> getManager("ManagerPlanesObrasSociales");
$managerObraSocial = $this -> getManager("ManagerObrasSociales");
$obraSocial = $managerObraSocial->get($this->request["obraSocial_idobraSocial"]);


$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
$this -> assign("obraSocial", $obraSocial);
?>