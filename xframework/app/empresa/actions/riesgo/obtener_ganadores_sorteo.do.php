<?php

$manag = $this->getManager("ManagerGanadoresRecompensa");
$manag->getGanadores($this->request["idcuestionario"]);
$this->finish($manag->getMsg());








