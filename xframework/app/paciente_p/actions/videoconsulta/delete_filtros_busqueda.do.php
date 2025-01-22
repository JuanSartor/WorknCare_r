<?php

$ManagerFiltrosBusqueda=$this->getManager("ManagerFiltrosBusquedaVideoConsulta");

$result=$ManagerFiltrosBusqueda->deleteFiltrosBusqueda($this->request["idvideoconsulta"]);

  $this->finish($ManagerFiltrosBusqueda->getMsg());