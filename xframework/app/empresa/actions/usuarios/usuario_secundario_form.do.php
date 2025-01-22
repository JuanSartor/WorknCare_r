<?php
/**
 * Método que agrega el usuario secundario
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
$result = $manager->agregarUsuarioSecundario($this->request);
$this->finish($manager->getMsg());