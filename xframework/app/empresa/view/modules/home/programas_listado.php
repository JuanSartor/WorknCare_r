<?php

$ManagerProgramaSaludGE = $this->getManager("ManagerProgramaSaludGrupoEmpresa");
$listaGrupoEmpre = $ManagerProgramaSaludGE->getListadoGrupoProgramas();
$ManagerProgramaSaludCategoria = $this->getManager("ManagerProgramaSaludCategoria");

$this->assign("listado_programas", $listaGrupoEmpre);


$ManagerProgramaSaludExcepcion = $this->getManager("ManagerProgramaSaludExcepcion");
$idempresa = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];

$excepciones_programa = $ManagerProgramaSaludExcepcion->getByField("empresa_idempresa", $idempresa);
$this->assign("excepciones_programa", $excepciones_programa);

// obtengo la Empresa
$ManagerEmpresa = $this->getManager("ManagerEmpresa");
$empresa = $ManagerEmpresa->get($idempresa);
$this->assign("idplanempresa", $empresa["plan_idplan"]);
