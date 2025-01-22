<?php

/**
 * metodo que activa la suscripcion y actualiza el plan de la empresa
 */
$this->start();
$managerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $managerEmpresa->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$actualizar["plan_idplan"] = $empresa["plan_idplan_siguiente"];
$actualizar["fecha_adhesion"] = date("Y-m-d");
$actualizar["fecha_vencimiento"] = date("Y-m-d", strtotime($actualizar["fecha_adhesion"] . "+ 1 year"));
if ($empresa["plan_idplan_siguiente"] == '20') {
    $actualizar["cant_empleados"] = 500;
}
$managerEmpresa->basic_update($actualizar, $empresa["idempresa"]);
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->activar_suscripcion_pack($this->request);
$this->finish($manager->getMsg());
