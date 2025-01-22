<?php

/**
 *  cargar link
 */
$reCapsula["titulo"] = $this->request["titulo_link"];
$reCapsula["tipo_capsula"] = '2';
$reCapsula["estado"] = '1';
$reCapsula["fecha_inicio"] = date("Y-m-d");

if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] != '') {
    $reCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
} else {
    // aca ingresa cuando carga desde dp admin el usuario empresa signifca eso porque lo carga desde el admin
    $reCapsula["usuarioempresa_idusuarioempresa"] = "0";
    $reCapsula["contenedorcapsula_idcontenedorcapsula"] = $this->request["contenedorcapsula_idcontenedorcapsula_link"];
}





$ManagerCa = $this->getManager("ManagerCapsula");
$idCapsula = $ManagerCa->process($reCapsula);
$reqLink["capsula_idcapsula"] = $idCapsula;
$reqLink["link"] = $this->request["input_link"];
$Manager = $this->getManager("ManagerLinkCapsula");
$result = $Manager->process($reqLink);

$this->finish($Manager->getMsg());

