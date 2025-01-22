<?php

$this->start();
$ManagerPerfilSaludControlVisualAntecedentes=$this->getManager("ManagerPerfilSaludControlVisualAntecedentes");
$ManagerPerfilSaludControlVisualAntecedentes->insert($this->request);
$this->finish($ManagerPerfilSaludControlVisualAntecedentes->getMsg());
