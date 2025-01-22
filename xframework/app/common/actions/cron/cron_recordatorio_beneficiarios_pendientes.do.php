<?php

/**
 * Cron encargado de enviar un recordatorio a los administradores de la cuenta empresa cuando hay beneficiarios pendientes de verificacion
 */
$ManagerPacienteEmpresa = $this->getManager("ManagerPacienteEmpresa");
$ManagerPacienteEmpresa->debug();

$ersultado = $ManagerPacienteEmpresa->cron_recordatorio_beneficiarios_pendientes();
