<?php

$manag = $this->getManager("ManagerRespuestasCuestionario");
$rdo = $manag->getListaBeneficiariosRegistrados($this->request["idcuestionario"]);

$managSorteo = $this->getManager("ManagerGanadoresRecompensa");
$managSorteo->sortearRecompensas($this->request["idcuestionario"], $rdo);
$this->finish($managSorteo->getMsg());








