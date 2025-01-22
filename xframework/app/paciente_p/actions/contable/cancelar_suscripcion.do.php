<?php

/**
 * Método que setea el flag para cancelar la suscripcion
 */
$this->start();
$manager = $this->getManager("ManagerEmpresa");
$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
$result = $manager->basic_update(["cancelar_suscripcion" => 1], $idempresa);
$this->finish($manager->getMsg());
