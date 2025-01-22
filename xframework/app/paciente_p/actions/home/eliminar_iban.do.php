<?php

/**
 * Método para eliminar iban 
 */
$manager = $this->getManager("ManagerIbanBeneficiario");

$resultado = $manager->deleteIban($this->request["idIbanBeneficiario"]);
$this->finish($manager->getMsg());
