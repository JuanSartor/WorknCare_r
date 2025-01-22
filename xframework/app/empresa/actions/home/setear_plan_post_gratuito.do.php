<?php

/**
 *  sete en la tabla empresa que plan selecciono para cambiar del gratuito a este seleccionado
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
//$manager->debug();
$empresa = $manager->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);

if ($this->request["cantidadEmpleados"] != '0') {
    $requUpCanEm["cant_empleados"] = $this->request["cantidadEmpleados"];
    $manager->basic_update($requUpCanEm, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
}

if ($empresa["obra_social"] == 1) {
    $this->request["cancelar_suscripcion"] = '0';
    $manager->basic_update($this->request, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
    $usuarioEmpresa = $this->getManager("ManagerUsuarioEmpresa")->getByField("empresa_idempresa", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
    $ManagerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
    $suscipcionPlan = $ManagerProgramaSaludSuscripcion->getByField("empresa_idempresa", $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
    if ($suscipcionPlan != '') {
        $ManagerProgramaSaludSuscripcion->delete($suscipcionPlan["idprograma_salud_suscripcion"]);
    }
    $crear_compra_pack = $ManagerProgramaSaludSuscripcion->crear_suscripcion_pack(["customerId" => $usuarioEmpresa["stripe_customerid"]]);
    if (!$crear_compra_pack) {
        $this->db->FailTrans();
        $this->db->CompleteTrans();
        $this->setMsg(["msg" => $ManagerProgramaSaludSuscripcion->getMsg(), "result" => false]);
        return false;
    } else {
        $this->finish($ManagerProgramaSaludSuscripcion->getMsg());
    }
} else {
    if ($this->request["plan_idplan_siguiente"] != '') {
        $requestp["plan_idplan_siguiente"] = $this->request["plan_idplan_siguiente"];
    }
    if ($this->request["cancelar_suscripcion"] != '') {
        $requestp["cancelar_suscripcion"] = $this->request["cancelar_suscripcion"];
    } else {
        $requestp["cancelar_suscripcion"] = '0';
    }
    $manager->basic_update($requestp, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"]);
    $this->finish($manager->getMsg());
}

