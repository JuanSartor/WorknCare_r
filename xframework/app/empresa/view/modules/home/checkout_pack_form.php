<?php

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($empresa["hash"]);
$this->assign("plan_contratado", $plan_contratado);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByHash($empresa["hash"]);
$this->assign("usuario_empresa", $usuario_empresa);

if ($usuario_empresa["cupon_descuento"] != "") {
    $cupon = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $usuario_empresa["cupon_descuento"]);
    $this->assign("cupon", $cupon);
}
//recuperamos la suscripcion de recompra de pack
$suscripcion = $this->getManager("ManagerProgramaSaludSuscripcion")->get($this->request["id"]);
if ($suscripcion["client_secret"] != "" && $suscripcion["empresa_idempresa"] == $idempresa) {
    $cantidad = $suscripcion["pack_recompra"];
    $this->assign("cantidad", $cantidad);
    $this->assign("clientSecret", $suscripcion["client_secret"]);
    $this->assign("compra_suscripcion_pendiente", $suscripcion);
}

