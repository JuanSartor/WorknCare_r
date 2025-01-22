<?php

$idempresa = $this->request["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$empresa["fecha_adhesion_format"] = fechaToString($empresa["fecha_adhesion"]);
$empresa["fecha_vencimiento_format"] = fechaToString($empresa["fecha_vencimiento"]);
$this->assign("empresa", $empresa);

if ($empresa["direccion"] == "" || $empresa["codigo_postal"] == "" || $empresa["ciudad"] == "" || ($empresa["tipo_cuenta"] == "1" && $empresa["siren"] == "")) {
    $this->assign("completar_info_facturacion", "1");
}
$listado_facturas = $this->getManager("ManagerProgramaSaludSuscripcion")->get_facturas($idempresa, 1);
$this->assign("listado_facturas", $listado_facturas);
//print_r($listado_facturas);

$metodo_pago = $this->getManager("ManagerProgramaSaludSuscripcion")->get_metodo_pago($idempresa);

$this->assign("metodo_pago", $metodo_pago);
