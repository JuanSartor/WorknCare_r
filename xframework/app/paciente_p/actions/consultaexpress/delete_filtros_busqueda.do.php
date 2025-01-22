<?php

$ManagerFiltrosBusqueda=$this->getManager("ManagerFiltrosBusquedaConsultaExpress");

$result=$ManagerFiltrosBusqueda->deleteFiltrosBusqueda($this->request["idconsultaExpress"]);

  $this->finish($ManagerFiltrosBusqueda->getMsg());