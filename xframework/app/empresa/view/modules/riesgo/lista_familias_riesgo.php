<?php

/**
 *  0 mis modelos
 *  1 modelos DUERP
 */
$this->assign("banderaModelo", $this->request["modelos_riesgo_idmodelos_riesgo"]);

$ManagerModelo = $this->getManager("ManagerModeloRiesgo");
$listModelos = $ManagerModelo->getListadoModelosTodos($this->request["modelos_riesgo_idmodelos_riesgo"]);

$ManagerFam = $this->getManager("ManagerFamiliaRiesgo");
foreach ($listModelos as $key => $modelo) {

    $listado_familias = $ManagerFam->getListadoFamiliasPorModelo(["modelos_riesgo_idmodelos_riesgo" => $modelo["idmodelos_riesgos"]]);

    $listModelos[$key]["listado_familias"] = $listado_familias;
}

$this->assign("listado", $listModelos);

$this->assign("empresa_logueada", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
$this->assign("usuario_empresa", $usuario_empresa);
