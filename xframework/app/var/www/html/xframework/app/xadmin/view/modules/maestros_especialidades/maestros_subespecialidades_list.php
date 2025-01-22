<?php
/**
 *
 *  planes de las obras Sociales List
 *
 */

$manager = $this -> getManager("ManagerSubEspecialidades");
$managerEspecialidad = $this -> getManager("ManagerEspecialidades");
$especialidad = $managerEspecialidad->get($this->request["especialidad_idespecialidad"]);


$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);
$this -> assign("especialidad", $especialidad);
?>