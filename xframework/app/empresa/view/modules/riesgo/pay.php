<?php

$ManagerCuestionario = $this->getManager("ManagerCuestionario");
$cuestionario = $ManagerCuestionario->get($this->request["cuestionarios_idcuestionario"]);
$this->assign("cuestionario", $cuestionario);

$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);


$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $ManagerEmpresa->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$this->assign("empresa", $empresa);

$ManagerPais = $this->getManager("ManagerPais");
$pais = $ManagerPais->get($empresa["pais"]);
$this->assign("pais", $pais);

$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByHash($empresa["hash"]);
$this->assign("usuario_empresa", $usuario_empresa);

$pago_recompensa = $this->getManager("ManagerPagoRecompensaEncuesta")->getByField("cuestionario_idcuestionario", $cuestionario["idcuestionario"]);
$this->assign("pago_recompensa", $pago_recompensa);

$combo_pais = $this->getManager("ManagerPais")->getCombo();
$this->assign("combo_pais", $combo_pais);

$managPagoRecom = $this->getManager("ManagerPagoRecompensaEncuesta");
$listCuestionariosListos = $managPagoRecom->getListCuestionListosEmpresa();
$this->assign("cantCuestionariosListos", $listCuestionariosListos["cantidad"]);



