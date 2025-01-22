<?php

/**
 *
 *  Grupos de Programas de salud
 *
 */
$manager = $this->getManager("ManagerProgramaSaludGrupoEmpresa");

$paginate = SmartyPaginate::getPaginate($manager->getDefaultPaginate());

$this->assign("paginate", $paginate);
