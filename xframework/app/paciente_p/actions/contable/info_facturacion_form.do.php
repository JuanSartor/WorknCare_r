<?php
/**
 * Método que agrega info de facturacion
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");

$result = $manager->agregarInfoFacturacion($this->request);
$this->finish($manager->getMsg());