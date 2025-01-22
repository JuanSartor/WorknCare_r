<?php

/**
 * creo el intent para el pago con tarjeta en stripe
 */
$ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");
$ManagerCustomerStripe->crear_setup_intent_cuestionario($this->request["customerId"], $this->request["idPagoRecomensa"]);
$this->finish($ManagerCustomerStripe->getMsg());
