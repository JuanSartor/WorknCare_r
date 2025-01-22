<?php

$listado_web_profesional = $this->getManager("ManagerMedicoWebProfesional")->listado_web_profesional($_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]);
$this->assign("listado_web_profesional", $listado_web_profesional);

