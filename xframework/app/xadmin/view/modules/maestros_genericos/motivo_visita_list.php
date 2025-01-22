<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerMotivoVisita");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
