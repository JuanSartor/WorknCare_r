<?php
/**
 * Método que modifica el Email  al usuario
 */
$this->start();
$manager = $this->getManager("ManagerUsuarioEmpresa");
$result = $manager->updateEmail($this->request, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"]);
$this->finish($manager->getMsg());