<?php

$ManagerFiltrosBusqueda=$this->getManager("ManagerFiltrosBusquedaVideoConsulta");

$result=$ManagerFiltrosBusqueda->insert($this->request);

  $this->finish($ManagerFiltrosBusqueda->getMsg());