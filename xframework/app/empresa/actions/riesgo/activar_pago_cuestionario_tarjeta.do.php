<?php

/**
 * action que activa el pago por tarjeta, seteo en base de datos y activo el cobro en stripe
 */
$pago = $this->getManager("ManagerPagoRecompensaEncuesta")->get($this->request["idpago_recompensa_encuesta"]);
$managerCues = $this->getManager("ManagerCuestionario");
$requesUCust["stripe_payment_method"] = $this->request["stripe_payment_method"];
$requesUCust["cuestionario_idcuestionario"] = $pago["cuestionario_idcuestionario"];
$requesU["estado"] = '1';

$managerCues->update($requesU, $pago["cuestionario_idcuestionario"]);

$managerCusto = $this->getManager("ManagerCustomerStripe");
$rdo = $managerCusto->process_cobro_cuestionario($requesUCust);
if ($rdo) {
    $managerPago = $this->getManager("ManagerPagoRecompensaEncuesta");
    $managerPago->update($this->request, $this->request["idpago_recompensa_encuesta"]);

    $manager = $this->getManager("ManagerEmpresa");
    $result = $manager->generar_hash_invitacion_cuestionario($requesUCust["cuestionario_idcuestionario"]);
    $this->finish($manager->getMsg());
} else {
    print("error");
}