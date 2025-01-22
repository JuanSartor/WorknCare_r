<?php

/**
 *  cargar file
 */
$Manager = $this->getManager("ManagerCapsula");

$Manager->update($this->request, $this->request["idcapsula"]);
$this->finish($Manager->getMsg());

