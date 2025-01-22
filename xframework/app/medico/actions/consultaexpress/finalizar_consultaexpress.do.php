<?php

$manager = $this->getManager("ManagerConsultaExpress");
$request["estadoConsultaExpress_idestadoConsultaExpress"]=8;
$request["idconsultaExpress"] = $this->request["id"];

$manager->cambiarEstado($request);
$this->finish($manager->getMsg());


