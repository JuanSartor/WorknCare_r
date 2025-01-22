<?php

$this->start();
$ManagerPaciente=$this->getManager("ManagerPaciente");
$listado=$ManagerPaciente->getListadoPacientesDP(["query_str"=>$this->request["query_str"]]);

if($listado){
    $this->assign("listado_pacientes",$listado);
}