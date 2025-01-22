<?php

$listado_vacaciones = $this->getManager("ManagerMedicoVacaciones")->listado_vacaciones();
$this->assign("listado_vacaciones", $listado_vacaciones);

