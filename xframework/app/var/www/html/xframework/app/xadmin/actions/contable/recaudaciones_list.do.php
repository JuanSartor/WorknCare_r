<?php

  /** 	
   * 	Accion: Grilla del Listado de las recaudaciones/importes de pago de los médicos
   * 	
   */
  $manager = $this->getManager("ManagerSolicitudPagoMedico");
//$manager->debug();
  $records = $manager->getListadoRecaudacionesJSON($this->request,$manager->getDefaultPaginate()."_recaudaciones");

  echo $records;
  