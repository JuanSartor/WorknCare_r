<?php

$ManagerMedico = $this->getManager("ManagerMedico");
$medico = $ManagerMedico->get($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["medico"]["idmedico"]);
$this->assign("medico", $medico);