<?php
/**
 * Método que modifica el Email y celular perteneciente al Médico
 */
$this->start();
$manager = $this->getManager("ManagerMedico");
$result = $manager->updateCelularEmail($this->request, $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
$this->finish($manager->getMsg());