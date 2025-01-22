<?php

/**
 *  insert de Reembolso y los archivos adjuntos
 */
if ($this->request["bandera_iban"] == '0') {
    $ManagerIban = $this->getManager("ManagerIbanBeneficiario");
    $ManagerIban->insertarIban($this->request);
}
$ManagerReembolso = $this->getManager("ManagerReembolso");
$result = $ManagerReembolso->cargarReembolso($this->request);
$this->finish($ManagerReembolso->getMsg());

