<?php

/**
 *  aca confirmo el pago en stripe y actualizo la tabla de pago_recompensa
 *   y pongo que genero el QR en 1 es decir ya no va a poder eliminar ni modificar el cuestionario
 */
//  este if indica que fue pagado con tarjeta entonces tengo que confrimar el pago
// si es con transferencia o gratuito no debo hacer esta confirmacion en stripe
if ($this->request["estadoPagoPendiente"] == '1') {
    $manager = $this->getManager("ManagerPagoRecompensaEncuesta");
//$manager->debug();
    $manager->confirmarPagoCuestionario($this->request["idcuestionario"]);
}


$managerCues = $this->getManager("ManagerCuestionario");
$managerCues->update(["genero_qr" => '1'], $this->request["idcuestionario"]);
$this->finish($managerCues->getMsg());


