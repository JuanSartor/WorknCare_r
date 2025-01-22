<?php

  /** 	
   * 	Accion: Grilla del Listado de las solicituddes de pago de los médicos
   * 	
   */
  $manager = $this->getManager("ManagerSolicitudPagoMedico");
//$manager->debug();
  $records = $manager->getListadoJSON($this->request,$manager->getDefaultPaginate());

  echo $records;
  