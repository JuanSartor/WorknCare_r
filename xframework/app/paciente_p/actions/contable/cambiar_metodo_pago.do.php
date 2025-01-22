<?php

/**
 * Método que setea un nuevo metodo de pago para la suscripcion
 */
$this->start();
$manager = $this->getManager("ManagerProgramaSaludSuscripcion");

$result = $manager->cambiar_metodo_pago_suscripcion($this->request["paymentMethodId"]);
$this->finish($manager->getMsg());
