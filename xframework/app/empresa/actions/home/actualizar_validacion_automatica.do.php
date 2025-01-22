<?php

$this->start();

$manager = $this->getManager("ManagerEmpresa");
$manager->update(["validacion_automatica" => $this->request["validacion_automatica"]], $this->request["idempresa"]);
$this->finish($manager->getMsg());
