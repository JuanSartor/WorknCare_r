<?php

$ManagerProfesionalFavorito=$this->getManager("ManagerProfesionalFavorito");
$result=$ManagerProfesionalFavorito->marcarFavorito($this->request["idmedico"]);
$this->finish($ManagerProfesionalFavorito->getMsg());

