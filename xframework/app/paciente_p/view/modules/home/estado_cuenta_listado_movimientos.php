<?php

$ManagerMovimientoCuenta = $this->getManager("ManagerMovimientoCuenta");
  $paginate = "listado_estado_cuenta";

 
  $this->assign("idpaginate", $paginate);

  $listado_movimimientoCuenta = $ManagerMovimientoCuenta->getListadoMovimientosPaciente($this->request, $paginate);
  $this->assign("listado_movimiento_cuenta",$listado_movimimientoCuenta);

 
 

