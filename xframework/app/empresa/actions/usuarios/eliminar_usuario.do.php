<?php
/**
 * Método que agrega el usuario secundario
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
$result = $manager->eliminarUsuarioSecundario($this->request);
$this->finish($manager->getMsg());