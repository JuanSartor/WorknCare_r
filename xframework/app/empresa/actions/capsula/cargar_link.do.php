<?php

/**
 *  cargar link
 */
$reCapsula["titulo"] = $this->request["titulo"];
$reCapsula["tipo_capsula"] = '2';
$reCapsula["estado"] = '1';
$reCapsula["fecha_inicio"] = date("Y-m-d");
$reCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
$reCapsula["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

$ManagerCa = $this->getManager("ManagerCapsula");
$idCapsula = $ManagerCa->process($reCapsula);
$reqLink["capsula_idcapsula"] = $idCapsula;
$reqLink["link"] = $this->request["input_link"];
$Manager = $this->getManager("ManagerLinkCapsula");
$result = $Manager->process($reqLink);

$this->finish($Manager->getMsg());

