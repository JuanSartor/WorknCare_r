<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerServiciosMedicos");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
?>