<?php

/**
 *  cargar file
 */
$Manager = $this->getManager("ManagerEmpresa");

$Manager->update($this->request, $this->request["idempresa"]);
$this->finish($Manager->getMsg());

