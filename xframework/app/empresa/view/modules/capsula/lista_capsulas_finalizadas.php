<?php

// obtengo los cuestionarios asociados a la familia pasada como parametro
$ManagerCuestionario = $this->getManager("ManagerCapsula");
$listadoCapsulas = $ManagerCuestionario->getListadoCapsulasFinalizadas();
$this->assign("listado_capsulas", $listadoCapsulas);

$this->assign("empresa_logueada", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);

$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
$this->assign("usuario_empresa_logueado", $usuario_empresa);
