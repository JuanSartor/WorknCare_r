<?php

$ManagerCuestionario = $this->getManager("ManagerCapsula");

$list_cuestionarios = $ManagerCuestionario->getCapsulasEmpresa();

$this->assign("list_cuestionarios", $list_cuestionarios);

