<?php

/**
 * Cron encargado de recuperar las consultas finalizadas y procisar el cobro en la plataforma de Stripe
 */
$ManagerCustomerStripe = $this->getManager("ManagerCustomerStripe");

$ManagerCustomerStripe->cron_procesar_cobros_consulta();
