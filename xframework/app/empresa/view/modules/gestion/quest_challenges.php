<?php

$ManagerCuestionario = $this->getManager("ManagerCuestionario");

$list_cuestionarios = $ManagerCuestionario->getCuestionariosEmpresa();

$this->assign("list_cuestionarios", $list_cuestionarios);

