<?php

/**
 * Método que anula la cancelacion de la suscripcion
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$result = $manager->basic_update(["cancelar_suscripcion" => 0], $idempresa);
$this->finish($manager->getMsg());
