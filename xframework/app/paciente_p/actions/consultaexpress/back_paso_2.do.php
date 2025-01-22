<?php

$ManagerConsultaExpress=$this->getManager("ManagerConsultaExpress");
$request=$this->request;
$request["medico_idmedico"]="";
$request["ids_medicos_bolsa"]="";
$request["consulta_step"]="1";
$result=$ManagerConsultaExpress->update($request,$request["idconsultaExpress"]);
$this->finish($ManagerConsultaExpress->getMsg());

