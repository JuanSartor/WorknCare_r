<?php

$plan_contratado = $this->getManager("ManagerProgramaSaludPlan")->getByUser($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
$this->assign("plan_contratado", $plan_contratado);

$plan_detalle = $this->getManager("ManagerProgramaSaludPlan")->get($plan_contratado["idprograma_salud_plan"]);
$this->assign("plan_detalle", $plan_detalle);

$usuario_empresa = $this->getManager("ManagerUsuarioEmpresa")->get($_SESSION[URL_ROOT]["empresa"]['logged_account']["id"]);
$this->assign("usuario_empresa", $usuario_empresa);

$info_beneficiarios = $this->getManager("ManagerPacienteEmpresa")->getInfoBeneficiariosInscriptos($_SESSION[URL_ROOT]["empresa"]['logged_account']["user"]["idempresa"]);

$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$empresa = $this->getManager("ManagerEmpresa")->get($idempresa);
$this->assign("empresa", $empresa);
if ($empresa["direccion"] == "" || $empresa["codigo_postal"] == "" || $empresa["siren"] == "") {
    $this->assign("completar_info_facturacion", "1");
}

if ($empresa["cupon_descuento"] != "") {
    $cupon = $this->getManager("ManagerProgramaSaludCupon")->getByField("codigo_cupon", $empresa["cupon_descuento"]);
    $this->assign("cupon", $cupon);
}
//calculamos el consumo de los beneficiarios
$plan = $this->getManager("ManagerProgramaSaludPlan")->get($empresa["plan_idplan"]);
if ((int) $info_beneficiarios["beneficiarios_verificados"] > 0 && (int) $empresa["presupuesto_maximo"] > 0) {
    $info_beneficiarios["consumo_beneficiarios"] = $info_beneficiarios["beneficiarios_verificados"] * $plan["precio"];
    $info_beneficiarios["credito_disponible"] = $empresa["presupuesto_maximo"] - $info_beneficiarios["consumo_beneficiarios"];
}
//si es una obra social, verificamos la compra de packs
if ($empresa["obra_social"] == 1) {
    $compra_suscripcion_pendiente = $this->getManager("ManagerProgramaSaludSuscripcion")->getByFieldArray(["empresa_idempresa", "recompra"], [$idempresa, 1]);
    if ($compra_suscripcion_pendiente["pack_pago_pendiente"] == 1) {
        $this->assign("compra_suscripcion_pendiente", $compra_suscripcion_pendiente);
    }
}


$this->assign("info_beneficiarios", $info_beneficiarios);
$this->assign("STRIPE_APIKEY_PUBLIC", STRIPE_APIKEY_PUBLIC);

$managaPa = $this->getManager("ManagerPagoRecompensaEncuesta");
$cuestionario_listo = $managaPa->getCuestionListoEmpresa();
$this->assign("cuestionario_listo", $cuestionario_listo);
$pagoRecom = $managaPa->getPagoPendienteFactura();
$this->assign("pagoRecom", $pagoRecom);

$manCues = $this->getManager("ManagerCuestionario");
$cant_cuestionario_preparado = $manCues->getCantidadCuestionariosPreparados();
$this->assign("cant_cuestionario_preparado", $cant_cuestionario_preparado);

$cant_cuestionario_finalizado = $manCues->getCantidadCuestionariosFinalizados();
$this->assign("cant_cuestionario_finalizado", $cant_cuestionario_finalizado);

$ManagerProgramaSaludSuscripcion = $this->getManager("ManagerProgramaSaludSuscripcion");
$planSus = $ManagerProgramaSaludSuscripcion->getByField("empresa_idempresa", $empresa["idempresa"]);
$this->assign("plansusempresa", $planSus);

$ultimo_cuestionario_finalizado = $manCues->getUltimoCuestionarioFinalizado();
$this->assign("ultimo_cuestionario_finalizado", $ultimo_cuestionario_finalizado);

$ManagerRe = $this->getManager("ManagerRespuestasCuestionario");
$respuestasAcuestionario = $ManagerRe->respuestaACuestionario($ultimo_cuestionario_finalizado["idcuestionario"]);
$cantReaspuestas = count($respuestasAcuestionario);
$this->assign("cantReaspuestas", $cantReaspuestas);

$tasa_de_respuesta = ($cantReaspuestas * 100) / $ultimo_cuestionario_finalizado["estimacion_cuestionarios_totales"];
$this->assign("tasa_de_respuesta", round($tasa_de_respuesta, 2));


$tranPackPend = $this->getManager("ManagerProgramaSaludSuscripcion")->getPagoPendienteTransPack();
$this->assign("tranPackPend", $tranPackPend);

$capsula_lista = $this->getManager("ManagerCapsula")->getCapsulaLista();
$this->assign("capsula_lista", $capsula_lista);

$cant_capsulaLista = $this->getManager("ManagerCapsula")->cantCapsulasListas();
$this->assign("cant_capsulaLista", $cant_capsulaLista["cant"]);

$cant_capsulaFinalizadas = $this->getManager("ManagerCapsula")->cantCapsulasFinalizadas();
$this->assign("cant_capsulaFinalizadas", $cant_capsulaFinalizadas["cant"]);

$cant_visitasCapsulaTotales = $this->getManager("ManagerCapsula")->cantVisitasTotales();
$this->assign("cant_visitasCapsulaTotales", $cant_visitasCapsulaTotales["cant"]);
