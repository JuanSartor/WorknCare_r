<?php

$ManagerFiltrosBusqueda=$this->getManager("ManagerFiltrosBusquedaConsultaExpress");

$result=$ManagerFiltrosBusqueda->insert($this->request);

  $this->finish($ManagerFiltrosBusqueda->getMsg());