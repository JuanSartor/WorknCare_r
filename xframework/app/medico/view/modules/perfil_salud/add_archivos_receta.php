<?php

$this->assign("idpaciente", $this->request["id"]);

$this->assign("idperfilSaludConsulta", $this->request["idperfilSaludConsulta"]);
$ManagerTipoReceta = $this->getManager("ManagerTipoReceta");
$this->assign("combo_tipo_receta", $ManagerTipoReceta->getCombo());

