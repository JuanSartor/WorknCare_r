<?php

/**
 * creo la suscripcion y actualizo los datos en la tabla empresa
 * esta suscripcion es posterior a el registro gratuito
 */
$this->start();
$managerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $managerEmpresa->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
$actualizar["plan_idplan"] = $empresa["plan_idplan_siguiente"];
$actualizar["fecha_adhesion"] = date("Y-m-d");
$actualizar["fecha_vencimiento"] = date("Y-m-d", strtotime($actualizar["fecha_adhesion"] . "+ 1 year"));
$managerEmpresa->basic_update($actualizar, $empresa["idempresa"]);
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");
$manager->crear_suscripcion($this->request);
$this->finish($manager->getMsg());
