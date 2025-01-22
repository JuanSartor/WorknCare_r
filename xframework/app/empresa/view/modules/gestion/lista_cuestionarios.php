<?php

// obtengo la familia para leer el nombre
$ManagerFamiliaCuestionario = $this->getManager("ManagerFamiliaCuestionario");
$familiaCuestionario = $ManagerFamiliaCuestionario->get($this->request["id_familia_cuestionario"]);
$this->assign("familia_cuestionario", $familiaCuestionario);

// obtengo los cuestionarios asociados a la familia pasada como parametro
$ManagerCuestionario = $this->getManager("ManagerCuestionario");
$listadoCuestionarios = $ManagerCuestionario->getListadoCuestionarios($this->request["id_familia_cuestionario"]);

$ManagerPregunta = $this->getManager("ManagerPregunta");
$ManagerPreguntaAbierta = $this->getManager("ManagerPreguntaAbierta");
foreach ($listadoCuestionarios as $key => $cuestionario) {

    $listado_preguntas_cerradas = $ManagerPregunta->getListadoPreguntas(["cuestionarios_idcuestionario" => $cuestionario["idcuestionario"]]);
    $listado_preguntas_abiertas = $ManagerPreguntaAbierta->getListadoPreguntas(["cuestionario_idcuestionario" => $cuestionario["idcuestionario"]]);

    $listado_preguntas = array_merge($listado_preguntas_abiertas, $listado_preguntas_cerradas);
    $listadoCuestionarios[$key]["listado_preguntas"] = $listado_preguntas;
}

$this->assign("listado_cuestionarios", $listadoCuestionarios);

$this->assign("empresa_logueada", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
$this->assign("usuario_empresa", $usuario_empresa);
