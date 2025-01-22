<?php

/**
 *
 *  Usuarios de empresas
 *
 */
$manager = $this->getManager("ManagerUsuarioEmpresa");

$paginate = SmartyPaginate::getPaginate("usuario_empresa_listado");

$this->assign("paginate", $paginate);
$this->assign("estados", $manager->getComboEstados(true));
$this->assign("combo_planes", $this->getManager("ManagerProgramaSaludPlan")->getCombo());

?>