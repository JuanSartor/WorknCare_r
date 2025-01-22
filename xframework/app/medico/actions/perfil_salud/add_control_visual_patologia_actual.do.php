<?php

$this->start();
$ManagerPerfilSaludControlVisualAntecedentes=$this->getManager("ManagerPerfilSaludControlVisualAntecedentes");
$ManagerPerfilSaludControlVisualAntecedentes->insert_patologia_actual($this->request);
$this->finish($ManagerPerfilSaludControlVisualAntecedentes->getMsg());
