<?php
/**
 *
 *  Tipo Familiar
 *
 */

$manager = $this -> getManager("ManagerTipoFamiliar");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
