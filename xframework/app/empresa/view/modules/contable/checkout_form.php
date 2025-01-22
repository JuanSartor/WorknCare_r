<?php

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);

$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan_siguiente"]);
$this->assign("plan_contratado", $plan_contratado);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("empresa_idempresa", $empresa["idempresa"]);
$this->assign("usuario_empresa", $usuario_empresa);

if ($usuario_empresa["cupon_descuento"] != "") {
    $cupon = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $usuario_empresa["cupon_descuento"]);
    $this->assign("cupon", $cupon);
}
$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);
$fechaActual = fechaToString(date('Y-m-d'));
$this->assign("fechaActual", $fechaActual);
