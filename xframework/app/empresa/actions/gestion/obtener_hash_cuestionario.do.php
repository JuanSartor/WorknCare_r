<?php

$manag = $this->getManager("ManagerEmpresaInvitacionCuestionario");
$rdo = $manag->getultimoHash($this->request["idcuestionario"]);

$this->finish($manag->getMsg());

