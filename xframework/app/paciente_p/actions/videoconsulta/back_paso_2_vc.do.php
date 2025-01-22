<?php

$ManagerVideoConsulta=$this->getManager("ManagerVideoConsulta");
$request=$this->request;
$request["medico_idmedico"]="";
$request["ids_medicos_bolsa"]="";
$request["consulta_step"]="1";
$result=$ManagerVideoConsulta->update($request,$request["idvideoconsulta"]);
$this->finish($ManagerVideoConsulta->getMsg());

