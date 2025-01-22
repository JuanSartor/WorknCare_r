<?php

/**
 * Método que setea un nuevo metodo de pago para la suscripcion 
 * y crea una suscripcion para el caso de programas gratuitos
 */
$this->start();
$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("empresa_idempresa", $idempresa);

$suscripcion = $manager->getByField("empresa_idempresa", $idempresa);

if ($suscripcion != '') {
    $result = $manager->cambiar_metodo_pago_suscripcion($this->request["paymentMethodId"]);
    $this->finish($manager->getMsg());
} else {
    $managerEmpresa = $this->getManager("ManagerEmpresa");
    $empresa = $managerEmpresa->get($idempresa);
    $plan_siguiente = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan_siguiente"]);
    $this->request["priceId"] = $plan_siguiente["stripe_priceid"];
    $this->request["customerId"] = $usuario_empresa["stripe_customerid"];

    $manager->crear_suscripcion($this->request);
    $this->request["id"] = $empresa["plan_idplan_siguiente"];
    $this->request["banderaGratis"] = '1';
    $managerEmpresa->actualizar_suscripcion($this->request);
    $this->finish($managerEmpresa->getMsg());
}
