<?php

$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
$this->assign("paciente", $paciente);

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["empresa"]["idempresa"];

$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$empresa["fecha_adhesion_format"] = fechaToString($empresa["fecha_adhesion"]);
$empresa["fecha_vencimiento_format"] = fechaToString($empresa["fecha_vencimiento"]);
$this->assign("empresa", $empresa);



if ($empresa["direccion"] == "" || $empresa["codigo_postal"] == "" || $empresa["ciudad"] == "" || $empresa["pais"] == "" || ($empresa["tipo_cuenta"] == "1" && $empresa["siren"] == "")) {
    $this->assign("completar_info_facturacion", "1");
}
$listado_facturas = $this->getManager("ManagerProgramaSaludSuscripcion")->get_facturas($idempresa);
$this->assign("listado_facturas", $listado_facturas);
//print_r($listado_facturas);

$metodo_pago = $this->getManager("ManagerProgramaSaludSuscripcion")->get_metodo_pago($idempresa);
$this->assign("metodo_pago", $metodo_pago);

$paises_sepa = $this->getManager("ManagerPaisSepa")->getCombo();
$this->assign("paises_sepa", $paises_sepa);

//variables para cambio de metodo de pago
$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUserHash($empresa["hash"]);
$this->assign("plan_contratado", $plan_contratado);
$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->getByHash($empresa["hash"]);
$this->assign("usuario_empresa", $usuario_empresa);
$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);
