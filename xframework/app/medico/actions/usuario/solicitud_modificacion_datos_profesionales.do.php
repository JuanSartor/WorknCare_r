<?php

$this->start();
$ManagerMedico = $this->getManager("ManagerMedico");
$ManagerMedico->enviarMailSolicitudModificacionDatosProfesionales($this->request);
$this->finish($ManagerMedico->getMsg());

