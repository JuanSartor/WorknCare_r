<?php

$info_beneficiarios = $this->getManager("ManagerPacienteEmpresa")->getInfoBeneficiariosInscriptos($_SESSION[URL_ROOT]["empresa"]['logged_account']["user"]["idempresa"]);

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$this->assign("empresa", $empresa);
if ($empresa["direccion"] == "" || $empresa["codigo_postal"] == "" || $empresa["siren"] == "") {
    $this->assign("completar_info_facturacion", "1");
}
//calculamos el consumo de los beneficiarios
$plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
if ((int) $info_beneficiarios["beneficiarios_verificados"] > 0 && (int) $empresa["presupuesto_maximo"] > 0) {
    $info_beneficiarios["consumo_beneficiarios"] = $info_beneficiarios["beneficiarios_verificados"] * $plan["precio"];
    $info_beneficiarios["credito_disponible"] = $empresa["presupuesto_maximo"] - $info_beneficiarios["consumo_beneficiarios"];
}
$this->assign("info_beneficiarios", $info_beneficiarios);
