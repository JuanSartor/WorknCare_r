<?php

$managerEmprea = $this->getManager("ManagerEmpresa");
$managerEmprea->generar_hash_invitacion_cuestionario($this->request["idcuestionario"]);
$this->finish($managerEmprea->getMsg());
