<?php

$ManagerFiltroBusqueda=$this->getManager("ManagerFiltrosBusquedaVideoConsulta");
$rango_precios=$ManagerFiltroBusqueda->getRangoPrecioMedicosBolsa($this->request);

$this->assign("rango_precios",$rango_precios);
