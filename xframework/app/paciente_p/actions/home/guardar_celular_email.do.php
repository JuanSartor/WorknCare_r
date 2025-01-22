<?php
/**
 * Método que modifica el Email y celular perteneciente al Paciente
 */
$this->start();
$manager = $this->getManager("ManagerPaciente");
$result = $manager->updateCelularEmail($this->request, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["paciente"]["idpaciente"]);
$this->finish($manager->getMsg());