<?php

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("empresa_idempresa", $idempresa);
$this->assign("usuario_empresa", $usuario_empresa);
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan_siguiente"]);
$this->assign("plan_contratado", $plan_contratado);

if ($usuario_empresa["cupon_descuento"] != "") {
    $cupon = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $usuario_empresa["cupon_descuento"]);
    $this->assign("cupon", $cupon);
}
if ($plan_contratado) {
    if ($plan_contratado["idprograma_salud_plan"] == '20') {
        $cantidad = 500;
    } else {
        $cantidad = (int) $empresa["cant_empleados"];
    }
    $this->assign("cantidad", $cantidad);

    $suscripcion = $this->getManager("ManagerProgramaSaludSuscripcion")->getByField("empresa_idempresa", $usuario_empresa["empresa_idempresa"]);
    if ($suscripcion["client_secret"] != "") {
        $this->assign("clientSecret", $suscripcion["client_secret"]);
    }
}
$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);

