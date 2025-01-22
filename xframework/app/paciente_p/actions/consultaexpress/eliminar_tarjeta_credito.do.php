<?php

/**
 * Método para eliminar tarjeta de credito
 */
$manager = $this->getManager("ManagerCustomerStripe");
$resultado = $manager->eliminar_tarjeta_credito($this->request);

$this->finish($manager->getMsg());
