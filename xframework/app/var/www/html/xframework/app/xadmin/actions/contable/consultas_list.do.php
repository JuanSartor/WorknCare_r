<?php

  /** 	
   * 	Accion: Grilla del Listado de las consulas de un periodo
   * 	
   */
  $manager = $this->getManager("ManagerPeriodoPago");
//$manager->debug();
  $records = $manager->getListadoConsultasRecaudacionesJSON($this->request,"recaudaciones_consultas_list");

  echo $records;
  