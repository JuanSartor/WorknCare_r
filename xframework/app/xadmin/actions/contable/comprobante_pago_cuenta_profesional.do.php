<?php

  /*   
   * Accion: se retorna el listado de cuotas de suscripciones de cuentas profesionales y sus comporbantes asociados facturados o pendientes
   * 
   */

  $Manager = $this->getManager("ManagerCuota");
//$Manager->debug();
  $record = $Manager->getListadoComprobantesCuotaJSON($this->request, $Manager->getDefaultPaginate());

  echo $record;
  