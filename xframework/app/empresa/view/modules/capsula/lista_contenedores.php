<?php

// obtengo la familia para leer el nombre
$ManagerFamiliaCuestionario = $this->getManager("ManagerFamiliaCapsula");
$familiaCuestionario = $ManagerFamiliaCuestionario->get($this->request["familia_capsula_id_familia_capsula"]);
$this->assign("familia_cuestionario", $familiaCuestionario);

// obtengo los cuestionarios asociados a la familia pasada como parametro
$ManagerCuestionario = $this->getManager("ManagerContenedorCapsula");
$r["id_familia_capsula"] = $this->request["familia_capsula_id_familia_capsula"];
$listadoContenedores = $ManagerCuestionario->getListadoContenedores($r);

$ManagerC = $this->getManager("ManagerCapsula");
foreach ($listadoContenedores as $key => $contenedor) {
    $rq["contenedorcapsula_idcontenedorcapsula"] = $contenedor["idcontenedorcapsula"];
    $listado_c = $ManagerC->getListadoCapsulasFormContenedor($rq);
    $listadoContenedores[$key]["listado_capsulas"] = $listado_c;
}

$this->assign("listado_cuestionarios", $listadoContenedores);

$this->assign("empresa_logueada", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
$this->assign("usuario_empresa", $usuario_empresa);
