<?php

$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($this->request["id"]);
$this->assign("plan_contratado", $plan_contratado);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByHash($this->request["id"]);
$this->assign("usuario_empresa", $usuario_empresa);

if ($usuario_empresa["cupon_descuento"] != "") {
    $cupon = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $usuario_empresa["cupon_descuento"]);
    $this->assign("cupon", $cupon);
}
if ($plan_contratado) {

    $suscripcion = $this->getManager("ManagerProgramaSaludSuscripcion")->getByField("empresa_idempresa", $usuario_empresa["empresa_idempresa"]);
    if ($suscripcion["client_secret"] != "") {
        $this->assign("clientSecret", $suscripcion["client_secret"]);
    }
}

