<?php
/**
 *
 *  Medicamentos >> List
 *
 */

$manager = $this -> getManager("ManagerMedicamento");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
