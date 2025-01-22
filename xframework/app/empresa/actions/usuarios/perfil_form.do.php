<?php
/**
 * Método que modifica el usuario
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
$result = $manager->saveDatosCuenta($this->request);
$this->finish($manager->getMsg());