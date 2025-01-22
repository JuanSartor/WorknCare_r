<?php
/**
 *
 *  OBras Sociales List
 *
 */

$manager = $this -> getManager("ManagerMedico");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this -> assign("paginate", $paginate);

$this->assign("combo_especialidades",$this->getManager("ManagerEspecialidades")->getCombo(1));
  
  
?>