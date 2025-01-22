<?php

/**
 *  cargar file
 */
$Manager = $this->getManager("ManagerCuestionario");

$Manager->update($this->request, $this->request["idcuestionario"]);
$this->finish($Manager->getMsg());

